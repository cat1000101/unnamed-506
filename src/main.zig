const std = @import("std");
const print = std.debug.print;

const Circle: type = struct {
    radius: f32 = 10,
    velocity: f32 = 10,
    acceleration: f32 = 5,
    position: @Vector(2, f64) = @Vector(2, f64){ 100, 100 },

    pub fn init(radius: f32, velocity: f32, acceleration: f32, position: @Vector(2, f64)) Circle {
        return Circle{
            .radius = radius,
            .velocity = velocity,
            .acceleration = acceleration,
            .position = position,
        };
    }
};

pub fn main() !void {
    print("meow");
}

test "simple test" {}
