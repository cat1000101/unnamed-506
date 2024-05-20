const std = @import("std");

const lexer: type = struct {
    input: [*]u8,
    text_length: u64,
    position: usize,
};

pub fn main() !void {
    const text = "meow";
    const index = 3;
    std.debug.print("{c}", .{text[index]});
}

test "simple test" {}
