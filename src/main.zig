const std = @import("std");
const socket_listener = @import("socket_listener.zig");

pub fn main() !void {
    try socket_listener.run();
}
