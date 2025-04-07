const std = @import("std");
const common = @import("common");

pub fn run() !void {
    while (true) {
        const sock = try std.posix.socket(std.posix.AF.INET, std.posix.SOCK.DGRAM, std.posix.IPPROTO.UDP);
        defer std.posix.close(sock);

        const addr = try std.net.Address.resolveIp(common.parseArgsAsIp(), 55555);
        try std.posix.bind(sock, &addr.any, addr.getOsSockLen());

        // TODO: Define the len of the buffer on the common api to handle scenarios
        // where the buffer is too short or something.
        var buf: [256]u8 = undefined;
        const len = try std.posix.recvfrom(sock, &buf, 0, null, null);
        std.debug.print("recv: {s}\n", .{buf[0..len]});
    }
}
