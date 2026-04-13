const std = @import("std");
const pq = @cImport({
    @cInclude("libpq-fe.h");
});

pub const PgSink = struct {
    conn: ?*pq.PGconn,

    pub fn connect(allocator: std.mem.Allocator, uri: []const u8) !PgSink {
        const uri_z = try allocator.dupeZ(u8, uri);
        defer allocator.free(uri_z);
        const conn = pq.PQconnectdb(uri_z.ptr);
        if (conn == null) return error.PgConnectFailed;
        if (pq.PQstatus(conn) != pq.CONNECTION_OK) {
            const err = pq.PQerrorMessage(conn);
            std.debug.print("PQconnectdb: {s}\n", .{std.mem.span(err)});
            _ = pq.PQfinish(conn);
            return error.PgConnectFailed;
        }
        return .{ .conn = conn };
    }

    pub fn deinit(self: *PgSink) void {
        if (self.conn) |c| {
            pq.PQfinish(c);
            self.conn = null;
        }
    }

    /// Inserts one row into `rfid_read_event` (must match `apps/server/db/rfid_tour.sql`).
    pub fn insertRfidRead(
        self: *PgSink,
        allocator: std.mem.Allocator,
        reader_id: []const u8,
        antenna_id: u16,
        epc: []const u8,
        seen_at_ms: i64,
        rssi: i8,
        source: []const u8,
    ) !void {
        const conn = self.conn orelse return error.NotConnected;

        const reader_z = try allocator.dupeZ(u8, reader_id);
        defer allocator.free(reader_z);
        const epc_z = try allocator.dupeZ(u8, epc);
        defer allocator.free(epc_z);
        const source_z = try allocator.dupeZ(u8, source);
        defer allocator.free(source_z);

        var antenna_buf: [16]u8 = undefined;
        const antenna_str = try std.fmt.bufPrint(&antenna_buf, "{d}", .{antenna_id});
        const antenna_z = try allocator.dupeZ(u8, antenna_str);
        defer allocator.free(antenna_z);

        var ms_buf: [32]u8 = undefined;
        const ms_str = try std.fmt.bufPrint(&ms_buf, "{d}", .{seen_at_ms});
        const ms_z = try allocator.dupeZ(u8, ms_str);
        defer allocator.free(ms_z);

        var rssi_buf: [8]u8 = undefined;
        const rssi_str = try std.fmt.bufPrint(&rssi_buf, "{d}", .{rssi});
        const rssi_z = try allocator.dupeZ(u8, rssi_str);
        defer allocator.free(rssi_z);

        const sql =
            \\INSERT INTO rfid_read_event (reader_id, antenna_id, epc, seen_at, rssi_dbm, source)
            \\VALUES ($1, $2, $3, to_timestamp($4::double precision / 1000.0), $5::smallint, $6)
        ;

        const v: [6][*c]const u8 = .{
            reader_z.ptr,
            antenna_z.ptr,
            epc_z.ptr,
            ms_z.ptr,
            rssi_z.ptr,
            source_z.ptr,
        };

        const result = pq.PQexecParams(
            conn,
            sql,
            6,
            null,
            @ptrCast(&v),
            null,
            null,
            0,
        );
        defer pq.PQclear(result);

        const st = pq.PQresultStatus(result);
        if (st != pq.PGRES_COMMAND_OK) {
            const err = pq.PQresultErrorMessage(result);
            std.debug.print("rfid_read_event insert failed ({d}): {s}\n", .{ st, std.mem.span(err) });
            return error.PgExecFailed;
        }
    }
};
