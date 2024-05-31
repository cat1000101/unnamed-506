const std = @import("std");

const lexer: type = struct {
    input: [*]const u8,
    text_length: usize,
    position: usize,
    read_position: usize,
};

const Token:type = struct{
    
}

fn lex(text: []const u8) []Token {}


pub fn main() !void {
    const text = "mewo meow meow meow";
    const lexed: []const Token = lex(text);

    const parsed = parser(lexed);

    const result = convert(parsed);

    std.debug.print(result);
}

test "simple test" {}
