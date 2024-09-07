const std = @import("std");
const posix = std.posix;
const libc = @cImport({
    @cInclude("arpa/inet.h");
    @cInclude("sys/socket.h");
});

const httpServer = struct {
    sockfd: posix.socket_t,
    address: posix.sockaddr.in,

    fn init(domain: u32, socketType: u32, protocol: u32, backlog: u32, address: posix.sockaddr.in) !httpServer {
        const sockfd = posix.socket(
            domain,
            socketType,
            protocol,
        ) catch |err| {
            std.debug.print("failed to make socket {}", .{err});
            return err;
        };

        posix.bind(
            sockfd,
            @ptrCast(&address),
            @sizeOf(@TypeOf(address)),
        ) catch |err| {
            std.debug.print("failed to bind {}", .{err});
            return err;
        };

        posix.listen(sockfd, @truncate(backlog)) catch |err| {
            std.debug.print("failed to listen {}", .{err});
            return err;
        };

        return .{
            .sockfd = sockfd,
            .address = address,
        };
    }

    fn deinit(self: httpServer) void {
        posix.close(self.sockfd);
    }
};

pub fn main() !void {
    var server = try httpServer.init(
        libc.AF_INET,
        libc.SOCK_STREAM,
        0,
        32,
        .{
            .family = libc.AF_INET,
            .port = 8080,
            .addr = libc.INADDR_ANY,
        },
    );
    defer server.deinit();

    std.debug.print("yippe i have a server\n", .{});
}
