const std = @import("std");

/// Prefer `DATABASE_URL` from the process environment, else parse `.env` / `../.env` in cwd.
pub fn loadDatabaseUrl(allocator: std.mem.Allocator) !?[]u8 {
    const from_env = std.process.getEnvVarOwned(allocator, "DATABASE_URL") catch |err| switch (err) {
        error.EnvironmentVariableNotFound => null,
        else => |e| return e,
    };
    if (from_env) |v| return v;

    const paths = [_][]const u8{ ".env", "../.env" };
    for (paths) |rel| {
        const file = std.fs.cwd().openFile(rel, .{}) catch continue;
        defer file.close();
        const raw = file.readToEndAlloc(allocator, 1024 * 1024) catch continue;
        defer allocator.free(raw);
        if (try parseDotEnvValue(allocator, raw, "DATABASE_URL")) |v| {
            return v;
        }
    }
    return null;
}

pub fn loadEnvKeyOrDefault(allocator: std.mem.Allocator, want_key: []const u8, default: []const u8) ![]u8 {
    const from_env = std.process.getEnvVarOwned(allocator, want_key) catch |err| switch (err) {
        error.EnvironmentVariableNotFound => null,
        else => |e| return e,
    };
    if (from_env) |v| return v;

    const paths = [_][]const u8{ ".env", "../.env" };
    for (paths) |rel| {
        const file = std.fs.cwd().openFile(rel, .{}) catch continue;
        defer file.close();
        const raw = file.readToEndAlloc(allocator, 1024 * 1024) catch continue;
        defer allocator.free(raw);
        if (try parseDotEnvValue(allocator, raw, want_key)) |v| {
            return v;
        }
    }
    return try allocator.dupe(u8, default);
}

fn parseDotEnvValue(allocator: std.mem.Allocator, raw: []const u8, want_key: []const u8) !?[]u8 {
    var iter = std.mem.splitScalar(u8, raw, '\n');
    while (iter.next()) |line| {
        const t = std.mem.trim(u8, line, " \r\t");
        if (t.len == 0 or t[0] == '#') continue;
        const eq = std.mem.indexOfScalar(u8, t, '=') orelse continue;
        const k = std.mem.trim(u8, t[0..eq], " \t");
        if (!std.mem.eql(u8, k, want_key)) continue;
        var val = std.mem.trim(u8, t[eq + 1 ..], " \t");
        if (val.len >= 2 and val[0] == '"' and val[val.len - 1] == '"') {
            val = val[1 .. val.len - 1];
        } else if (val.len >= 2 and val[0] == '\'' and val[val.len - 1] == '\'') {
            val = val[1 .. val.len - 1];
        }
        if (val.len == 0) return null;
        return try allocator.dupe(u8, val);
    }
    return null;
}
