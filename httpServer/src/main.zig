const std = @import("std");
const posix = std.posix;
const libc = @cImport({
    @cInclude("arpa/inet.h");
    @cInclude("sys/socket.h");
});

pub fn main() !void {
    const sockfd = posix.socket(
        libc.AF_INET,
        libc.SOCK_STREAM,
        0,
    ) catch |err| {
        std.debug.print("failed to make socket", .{});
        return err;
    };
    defer posix.close(sockfd);

    const server_addr: posix.sockaddr.in = .{
        .family = libc.AF_INET,
        .port = 8080,
        .addr = libc.INADDR_ANY,
    };

    posix.bind(
        sockfd,
        &server_addr,
        @sizeOf(server_addr),
    ) catch |err| {
        std.debug.print("failed to bind", .{});
        return err;
    };
}
