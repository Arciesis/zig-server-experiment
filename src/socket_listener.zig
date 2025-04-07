const std = @import("std");

pub fn run(ip_address: []const u8) !void {
    while (true) {
        const sock = try std.posix.socket(std.posix.AF.INET, std.posix.SOCK.DGRAM, std.posix.IPPROTO.UDP);
        defer std.posix.close(sock);

        const addr = try std.net.Address.resolveIp(ip_address, 55555);
        try std.posix.bind(sock, &addr.any, addr.getOsSockLen());

        var buf: [1024]u8 = undefined;
        const len = try std.posix.recvfrom(sock, &buf, 0, null, null);
        std.debug.print("recv: {s}\n", .{buf[0..len]});
    }
}
