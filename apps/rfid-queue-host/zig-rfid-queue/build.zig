const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "rfid_queue_host",
        .root_module = root_module,
    });

    exe.addIncludePath(b.path("../linux64_sdk/include"));
    exe.addLibraryPath(b.path("../linux64_sdk/lib"));
    exe.linkLibC();
    exe.linkSystemLibrary("ltk");
    exe.linkSystemLibrary("utils");
    exe.linkSystemLibrary("xml2");
    exe.linkSystemLibrary("stdc++");
    exe.linkSystemLibrary("rfidapi32");
    exe.linkSystemLibrary("pthread");

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the RFID queue host prototype");
    run_step.dependOn(&run_cmd.step);
}
