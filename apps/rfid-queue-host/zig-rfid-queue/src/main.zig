const std = @import("std");

const c = @cImport({
    @cInclude("rfidapi.h");
});

const TagEvent = struct {
    epc_hex: [128]u8,
    epc_len: usize,
    antenna_id: u16,
    peak_rssi: i8,
    seen_at_ms: i64,
};

/// At most one queue emission per distinct EPC per this many milliseconds (wall clock).
const dedupe_window_ms: i64 = 1000;

const TagDeduper = struct {
    alloc: std.mem.Allocator,
    mutex: std.Thread.Mutex = .{},
    last_emit_ms: std.StringHashMap(i64),

    fn init(a: std.mem.Allocator) TagDeduper {
        return .{ .alloc = a, .last_emit_ms = std.StringHashMap(i64).init(a) };
    }

    fn deinit(self: *TagDeduper) void {
        var it = self.last_emit_ms.iterator();
        while (it.next()) |e| {
            self.alloc.free(e.key_ptr.*);
        }
        self.last_emit_ms.deinit();
    }

    /// Returns true if this EPC may be emitted now; updates last-emitted time when true.
    fn shouldEmit(self: *TagDeduper, epc_hex: []const u8, now_ms: i64) !bool {
        self.mutex.lock();
        defer self.mutex.unlock();

        if (self.last_emit_ms.getPtr(epc_hex)) |ptr| {
            if (now_ms - ptr.* < dedupe_window_ms) return false;
            ptr.* = now_ms;
            return true;
        }
        const owned = try self.alloc.dupe(u8, epc_hex);
        errdefer self.alloc.free(owned);
        try self.last_emit_ms.put(owned, now_ms);
        return true;
    }
};

const TagQueue = struct {
    allocator: std.mem.Allocator,
    mutex: std.Thread.Mutex = .{},
    cond: std.Thread.Condition = .{},
    items: std.ArrayListUnmanaged(TagEvent) = .{},
    stopped: bool = false,
    dropped_count: usize = 0,
    max_items: usize,

    fn init(allocator: std.mem.Allocator, max_items: usize) TagQueue {
        return .{
            .allocator = allocator,
            .max_items = max_items,
        };
    }

    fn deinit(self: *TagQueue) void {
        self.items.deinit(self.allocator);
    }

    fn push(self: *TagQueue, item: TagEvent) !void {
        self.mutex.lock();
        defer self.mutex.unlock();

        if (self.items.items.len >= self.max_items) {
            _ = self.items.orderedRemove(0);
            self.dropped_count += 1;
        }

        try self.items.append(self.allocator, item);
        self.cond.signal();
    }

    fn popWait(self: *TagQueue) ?TagEvent {
        self.mutex.lock();
        defer self.mutex.unlock();

        while (self.items.items.len == 0 and !self.stopped) {
            self.cond.wait(&self.mutex);
        }

        if (self.items.items.len == 0 and self.stopped) return null;
        return self.items.orderedRemove(0);
    }

    fn stop(self: *TagQueue) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        self.stopped = true;
        self.cond.broadcast();
    }
};

var g_queue: ?*TagQueue = null;
var g_dedupe: ?*TagDeduper = null;

fn rfidCallback(reader_handle: c.RFID_HANDLE32, event_type: c.RFID_EVENT_TYPE) callconv(.c) void {
    if (event_type == c.TAG_READ_EVENT) {
        if (g_queue) |queue| {
            if (g_dedupe) |dedupe| {
                _ = drainReaderTags(reader_handle, queue, dedupe) catch {};
            }
        }
    } else if (event_type == c.DISCONNECTION_EVENT) {
        std.debug.print("Reader disconnected event received.\n", .{});
    }
}

fn maybeEnqueueTag(queue: *TagQueue, dedupe: *TagDeduper, event: TagEvent) !void {
    const epc = event.epc_hex[0..event.epc_len];
    if (!try dedupe.shouldEmit(epc, event.seen_at_ms)) return;
    try queue.push(event);
}

fn pushTagData(queue: *TagQueue, dedupe: *TagDeduper, tag_data: *c.TAG_DATA) !void {
    var event: TagEvent = .{
        .epc_hex = [_]u8{0} ** 128,
        .epc_len = 0,
        .antenna_id = @as(u16, @intCast(tag_data.antennaID)),
        .peak_rssi = @as(i8, @intCast(tag_data.peakRSSI)),
        .seen_at_ms = std.time.milliTimestamp(),
    };

    const tag_len: usize = @intCast(tag_data.tagIDLength);
    const max_in_bytes = @min(tag_len, event.epc_hex.len / 2);
    const src = tag_data.pTagID;
    if (src == null) return;

    var write_idx: usize = 0;
    var i: usize = 0;
    while (i < max_in_bytes) : (i += 1) {
        const byte = src[i];
        event.epc_hex[write_idx] = toHexNibble(byte >> 4);
        event.epc_hex[write_idx + 1] = toHexNibble(byte & 0x0F);
        write_idx += 2;
    }
    event.epc_len = write_idx;

    try maybeEnqueueTag(queue, dedupe, event);
}

fn drainReaderTags(reader_handle: c.RFID_HANDLE32, queue: *TagQueue, dedupe: *TagDeduper) !void {
    const tag = c.RFID_AllocateTag(reader_handle) orelse return error.AllocateTagFailed;
    defer _ = c.RFID_DeallocateTag(reader_handle, tag);

    while (true) {
        const status = c.RFID_GetReadTag(reader_handle, tag);
        if (status != c.RFID_API_SUCCESS) break;
        try pushTagData(queue, dedupe, tag);
    }
}

fn toHexNibble(nibble: u8) u8 {
    return if (nibble < 10) ('0' + nibble) else ('A' + (nibble - 10));
}

fn consumerLoop(queue: *TagQueue) !void {
    while (true) {
        const maybe_item = queue.popWait();
        if (maybe_item == null) break;
        const item = maybe_item.?;

        std.debug.print(
            "{{\"epc\":\"{s}\",\"antenna\":{},\"rssi\":{},\"seen_at_ms\":{}}}\n",
            .{ item.epc_hex[0..item.epc_len], item.antenna_id, item.peak_rssi, item.seen_at_ms },
        );
    }
}

fn checkStatus(status: c.RFID_STATUS, context: []const u8) !void {
    if (status == c.RFID_API_SUCCESS) return;
    const desc = c.RFID_GetErrorDescriptionA(status);
    const desc_slice: []const u8 = if (desc != null)
        std.mem.span(desc)
    else
        "(no description)";
    std.debug.print("{s} failed: status {} — {s}\n", .{ context, status, desc_slice });
    return error.RfidApiFailure;
}

fn readFileAlloc(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    var f = try std.fs.cwd().openFile(path, .{});
    defer f.close();
    const max = std.math.maxInt(usize);
    return try f.readToEndAlloc(allocator, max);
}

/// Load PEM/key material from path in `RFID_<name>` (e.g. `RFID_CLIENT_CERT` → file path).
fn loadOptionalEnvFile(allocator: std.mem.Allocator, env_name: []const u8) !?[]u8 {
    const path = std.process.getEnvVarOwned(allocator, env_name) catch |err| switch (err) {
        error.EnvironmentVariableNotFound => return null,
        else => |e| return e,
    };
    defer allocator.free(path);
    return try readFileAlloc(allocator, path);
}

fn loadOptionalEnvString(allocator: std.mem.Allocator, env_name: []const u8) !?[]u8 {
    return std.process.getEnvVarOwned(allocator, env_name) catch |err| switch (err) {
        error.EnvironmentVariableNotFound => return null,
        else => |e| return e,
    };
}

fn simulateReads(queue: *TagQueue, dedupe: *TagDeduper, seconds: u64) !void {
    // Many duplicate "reads" of the same EPC within each wall second; dedupe yields ~one line per second per tag.
    const bursts_per_second: u32 = 20;
    const burst_sleep_ns = std.time.ns_per_s / bursts_per_second;

    var sec: u64 = 0;
    while (sec < seconds) : (sec += 1) {
        var b: u32 = 0;
        while (b < bursts_per_second) : (b += 1) {
            var item: TagEvent = .{
                .epc_hex = [_]u8{0} ** 128,
                .epc_len = 0,
                .antenna_id = 1,
                .peak_rssi = -50,
                .seen_at_ms = std.time.milliTimestamp(),
            };
            const epc = try std.fmt.bufPrint(
                item.epc_hex[0..],
                "300833B2DDD901400000{X:0>4}",
                .{@as(u16, @intCast(sec % 10000))},
            );
            item.epc_len = epc.len;

            try maybeEnqueueTag(queue, dedupe, item);
            std.Thread.sleep(burst_sleep_ns);
        }
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var arg_it = std.process.args();
    _ = arg_it.next(); // executable

    const reader_ip = arg_it.next();
    // Reader mode: <ip> [<seconds>] or <ip> <port> <seconds> (port defaults to 5084)
    var reader_port: u32 = 5084;
    var seconds: u64 = 15;

    if (reader_ip) |_| {
        const a2 = arg_it.next();
        const a3 = arg_it.next();
        if (a2) |s| {
            if (a3) |t| {
                reader_port = try std.fmt.parseInt(u32, s, 10);
                seconds = try std.fmt.parseInt(u64, t, 10);
            } else {
                seconds = try std.fmt.parseInt(u64, s, 10);
            }
        }
    } else if (arg_it.next()) |seconds_arg| {
        seconds = try std.fmt.parseInt(u64, seconds_arg, 10);
    }

    var secure_llrp = false;
    if (std.process.getEnvVarOwned(allocator, "RFID_SECURE")) |v| {
        defer allocator.free(v);
        secure_llrp = std.ascii.eqlIgnoreCase(v, "1") or std.ascii.eqlIgnoreCase(v, "true") or std.ascii.eqlIgnoreCase(v, "yes");
    } else |_| {}
    if (arg_it.next()) |flag| {
        if (std.mem.eql(u8, flag, "secure")) secure_llrp = true;
    }

    var queue = TagQueue.init(allocator, 4096);
    defer queue.deinit();
    var dedupe = TagDeduper.init(allocator);
    defer dedupe.deinit();

    g_queue = &queue;
    g_dedupe = &dedupe;
    defer {
        g_queue = null;
        g_dedupe = null;
    }

    const consumer = try std.Thread.spawn(.{}, consumerLoop, .{&queue});
    defer consumer.join();

    if (reader_ip == null) {
        std.debug.print(
            "No reader IP provided, running in simulated mode for {d} seconds (duplicate reads deduped to ~1/s per EPC).\n",
            .{seconds},
        );
        try simulateReads(&queue, &dedupe, seconds);
        queue.stop();
        return;
    }

    const ip_z = try allocator.dupeZ(u8, reader_ip.?);
    defer allocator.free(ip_z);

    var reader_handle: c.RFID_HANDLE32 = null;
    var conn_info: c.CONNECTION_INFO = std.mem.zeroes(c.CONNECTION_INFO);
    conn_info.version = c.RFID_API3_5_1;

    var sec_info: c.SEC_CONNECTION_INFO = std.mem.zeroes(c.SEC_CONNECTION_INFO);

    var tls_client_cert: ?[]u8 = null;
    var tls_client_key: ?[]u8 = null;
    var tls_root_cert: ?[]u8 = null;
    var tls_phrase: ?[]u8 = null;
    defer {
        if (tls_client_cert) |b| allocator.free(b);
        if (tls_client_key) |b| allocator.free(b);
        if (tls_root_cert) |b| allocator.free(b);
        if (tls_phrase) |b| allocator.free(b);
    }

    if (secure_llrp) {
        tls_client_cert = try loadOptionalEnvFile(allocator, "RFID_CLIENT_CERT");
        tls_client_key = try loadOptionalEnvFile(allocator, "RFID_CLIENT_KEY");
        tls_root_cert = try loadOptionalEnvFile(allocator, "RFID_ROOT_CERT");
        tls_phrase = try loadOptionalEnvString(allocator, "RFID_KEY_PASSPHRASE");

        var validate_peer = false;
        if (std.process.getEnvVarOwned(allocator, "RFID_VALIDATE_PEER")) |v| {
            defer allocator.free(v);
            validate_peer = std.ascii.eqlIgnoreCase(v, "1") or std.ascii.eqlIgnoreCase(v, "true");
        } else |_| {}

        sec_info.secureMode = 1;
        sec_info.validatePeerCert = if (validate_peer) @as(c.BYTE, 1) else 0;
        if (tls_client_cert) |b| {
            sec_info.sizeCertBuff = @intCast(b.len);
            sec_info.clientCertBuff = @ptrCast(b.ptr);
        }
        if (tls_client_key) |b| {
            sec_info.sizeKeyBuff = @intCast(b.len);
            sec_info.clientKeyBuff = @ptrCast(b.ptr);
        }
        if (tls_root_cert) |b| {
            sec_info.sizeRootCertBuff = @intCast(b.len);
            sec_info.rootCertBuff = @ptrCast(b.ptr);
        }
        if (tls_phrase) |b| {
            sec_info.sizePhraseBuff = @intCast(b.len);
            sec_info.phraseBuff = @ptrCast(b.ptr);
        }
        conn_info.lpSecConInfo = &sec_info;
        std.debug.print("Using secure (TLS) LLRP (mutual TLS if client PEMs are set).\n", .{});
        if (tls_client_cert == null or tls_client_key == null) {
            std.debug.print(
                "Hint: secure FX LLRP usually needs client cert/key from the reader (same as Zebra J_RFIDHostSample1: client_crt.pem, client_key.pem, cacert.pem). Set RFID_CLIENT_CERT, RFID_CLIENT_KEY, RFID_ROOT_CERT, RFID_KEY_PASSPHRASE.\n",
                .{},
            );
        }
    } else {
        conn_info.lpSecConInfo = null;
    }

    const connect_timeout_ms: u32 = 60_000;
    const conn_status = c.RFID_ConnectA(&reader_handle, @ptrCast(ip_z.ptr), reader_port, connect_timeout_ms, &conn_info);
    if (conn_status != c.RFID_API_SUCCESS) {
        if (secure_llrp) {
            std.debug.print("SEC_CONNECTION_INFO.connStatus (OpenSSL hint): {}\n", .{sec_info.connStatus});
        }
        try checkStatus(conn_status, "RFID_ConnectA");
    }
    defer _ = c.RFID_Disconnect(reader_handle);

    _ = c.RFID_SetTraceLevel(reader_handle, c.TRACE_LEVEL_OFF);

    var tag_storage: c.TAG_STORAGE_SETTINGS = std.mem.zeroes(c.TAG_STORAGE_SETTINGS);
    if (c.RFID_GetTagStorageSettings(reader_handle, &tag_storage) == c.RFID_API_SUCCESS) {
        tag_storage.discardTagsOnInventoryStop = 1;
        _ = c.RFID_SetTagStorageSettings(reader_handle, &tag_storage);
    }

    var events = [_]c.RFID_EVENT_TYPE{
        c.TAG_READ_EVENT,
        c.DISCONNECTION_EVENT,
        c.BUFFER_FULL_WARNING_EVENT,
        c.BUFFER_FULL_EVENT,
    };

    try checkStatus(
        c.RFID_RegisterEventNotificationCallback(
            reader_handle,
            @ptrCast(&events),
            events.len,
            rfidCallback,
            null,
            null,
        ),
        "RFID_RegisterEventNotificationCallback",
    );

    var antenna_ids = [_]c.UINT16{1};
    var antenna_info: c.ANTENNA_INFO = std.mem.zeroes(c.ANTENNA_INFO);
    antenna_info.pAntennaList = @ptrCast(&antenna_ids);
    antenna_info.length = 1;

    try checkStatus(
        c.RFID_PerformInventory(reader_handle, null, &antenna_info, null, null),
        "RFID_PerformInventory",
    );
    defer _ = c.RFID_StopInventory(reader_handle);

    std.debug.print(
        "Connected to reader {s}:{d}. Collecting tags for {d} seconds...\n",
        .{ reader_ip.?, reader_port, seconds },
    );
    std.Thread.sleep(seconds * std.time.ns_per_s);

    queue.stop();
}
