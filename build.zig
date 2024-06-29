const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .wasm32,
        .os_tag = .wasi,
    });
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSmall,
    });

    const exe = b.addExecutable(.{
        .name = "main",
        .target = target,
        .optimize = optimize,
        .root_source_file = b.path("wasm/main.zig"),
    });
    exe.entry = .disabled;
    exe.rdynamic = true;

    b.getInstallStep().dependOn(&b.addInstallArtifact(exe, .{
        .dest_dir = .{ .override = .{ .custom = "docs" } },
    }).step);
    b.installFile("index.html", "docs/index.html");
    b.installFile("main.js", "docs/main.js");
}
