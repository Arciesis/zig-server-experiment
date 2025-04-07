const std = @import("std");
const socket_listener = @import("socket_listener.zig");

pub fn main() !void {
    const server_ip = parseArg();
    try socket_listener.run(server_ip);
}

pub fn parseArg() []const u8 {
    if (std.os.argv.len != 3) {
        @panic("You should pass as argument the server IP address (with --server-ip option)");
    }

    var server_ip: []const u8 = "127.0.0.1";
    var i: usize = 1;
    while (i < std.os.argv.len) : (i += 1) {
        const arg = std.mem.span(std.os.argv[i]);
        if (std.mem.eql(u8, arg, "--server-ip") and i + 1 < std.os.argv.len) {
            server_ip = std.mem.span(std.os.argv[i + 1]);
            i += 1;
        }
    }
    return server_ip;
}
