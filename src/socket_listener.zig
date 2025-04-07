const std = @import("std");

pub fn run() !void {
    while (true) {
        const sock = try std.posix.socket(std.posix.AF.INET, std.posix.SOCK.DGRAM, std.posix.IPPROTO.UDP);
        defer std.posix.close(sock);

        const addr = try std.net.Address.parseIp("127.0.0.1", 55555);
        try std.posix.bind(sock, &addr.any, addr.getOsSockLen());

        var buf: [1024]u8 = undefined;
        const len = try std.posix.recvfrom(sock, &buf, 0, null, null);
        std.debug.print("recv: {s}\n", .{buf[0..len]});
    }
}
