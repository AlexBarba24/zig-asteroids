const std = @import("std");
const rl = @import("raylib");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}~\n", .{"world!"});
    rl.InitWindow(800, 450, "Test");
}
