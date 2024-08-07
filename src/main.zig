const std = @import("std");
const print = std.debug.print;
const rl = @import("raylib");

const gravity: f32 = 100;

const Circle = struct {
    position: @Vector(2, f64),
    radius: f32,
    color: rl.Color,
    mass: f64,
    velocity: @Vector(2, f64),
    acceleration: @Vector(2, f64),

    pub fn init(position: @Vector(2, f64), radius: f32, color: rl.Color, mass: f64, velocity: @Vector(2, f64), acceleration: @Vector(2, f64)) Circle {
        return Circle{
            .position = position,
            .radius = radius,
            .color = color,
            .mass = mass,
            .velocity = velocity,
            .acceleration = acceleration,
        };
    }

    pub fn newVelocity(self: *Circle, dt: f64) void {
        self.velocity[0] = self.velocity[0] + dt * self.acceleration[0];
        self.velocity[1] = self.velocity[1] + dt * self.acceleration[1];
    }

    pub fn newPosition(self: *Circle, dt: f64) void {
        self.position[0] = self.position[0] + self.velocity[0] * dt + (std.math.pow(f64, dt, @as(f64, 2)) * self.acceleration[0]) / @as(f64, 2);
        self.position[1] = self.position[1] + self.velocity[1] * dt + (std.math.pow(f64, dt, @as(f64, 2)) * self.acceleration[1]) / @as(f64, 2);
    }

    pub fn newAcceleration(self: *Circle, acceleration: @Vector(2, f64)) void {
        self.acceleration = acceleration;
    }

    pub fn checkCollisionBorder(self: *Circle, screen: @Vector(2, f64)) void {
        if ((self.position[1] + @as(f64, self.radius)) <= screen[1]) self.velocity[1] = -self.velocity[1];
        if ((self.position[1] - @as(f64, self.radius)) >= 0) self.velocity[1] = -self.velocity[1];
        if ((self.position[0] + @as(f64, self.radius)) <= screen[0]) self.velocity[0] = -self.velocity[0];
        if ((self.position[0] - @as(f64, self.radius)) >= 0) self.velocity[0] = -self.velocity[0];
    }

    pub fn twoCirclesCollision(self: *Circle, other: *Circle) void {
        const n: @Vector(2, f64) = other.position - self.position;
        const distance: f64 = std.math.sqrt(n[0] * n[0] + n[1] * n[1]);
        const radiusSum = @as(f64, self.radius) + @as(f64, other.radius);

        // Check if circles are colliding
        if (distance < radiusSum) {
            const un: @Vector(2, f64) = n / @as(@Vector(2, f64), @splat(distance));
            const ut = @Vector(2, f64){ -un[1], un[0] };

            const v1 = self.velocity;
            const v2 = other.velocity;

            const v1n = un[0] * v1[0] + un[1] * v1[1];
            const v1t = ut[0] * v1[0] + ut[1] * v1[1];
            const v2n = un[0] * v2[0] + un[1] * v2[1];
            const v2t = ut[0] * v2[0] + ut[1] * v2[1];

            const v1n_prime = (v1n * (self.mass - other.mass) + 2 * other.mass * v2n) / (self.mass + other.mass);
            const v2n_prime = (v2n * (other.mass - self.mass) + 2 * self.mass * v1n) / (self.mass + other.mass);

            const v1n_prime_vec = un * @as(@Vector(2, f64), @splat(v1n_prime));
            const v1t_prime_vec = ut * @as(@Vector(2, f64), @splat(v1t));
            const v2n_prime_vec = un * @as(@Vector(2, f64), @splat(v2n_prime));
            const v2t_prime_vec = ut * @as(@Vector(2, f64), @splat(v2t));

            self.velocity = v1n_prime_vec + v1t_prime_vec;
            other.velocity = v2n_prime_vec + v2t_prime_vec;
        }
    }
};

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;
    const screenLengths = @Vector(2, f64){ screenWidth, screenHeight };
    var defaultPrng = std.Random.DefaultPrng.init(17);
    const random = defaultPrng.random();

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    // rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    const numCircles = 10;
    var circles: [numCircles]Circle = undefined;

    for (0..numCircles) |i| {
        const initialPosition = @Vector(2, f64){
            (random.float(f64)) * @as(f64, screenWidth),
            (random.float(f64)) * @as(f64, screenHeight),
        };
        const initialVelocity = @Vector(2, f64){
            (random.float(f64)) * @as(f64, 100),
            (random.float(f64)) * @as(f64, 100),
        };
        const initialAccelaration = @Vector(2, f64){ 0.0, gravity };
        circles[i] = Circle.init(initialPosition, 10.0, rl.Color.blue, 1, initialVelocity, initialAccelaration);
    }
    var last_time = rl.getTime();
    var dt: f64 = 0;
    //--------------------------------------------------------------------------------------

    // Main game loop
    // TODO: force between circles? atraction
    // TODO: springs between circles
    // TODO: make a soft body with springs
    // TODO: make the circles collide with the walls better (https://www.youtube.com/watch?v=eED4bSkYCB8&list=PL5AnY90COM7Dh9XNY-OHvlJODRYk_6swz)
    // make costum collition with rectengles
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key

        dt = rl.getTime() - last_time;
        last_time = rl.getTime();

        rl.beginDrawing();
        defer rl.endDrawing();
        for (0..numCircles) |i| {
            circles[i].newVelocity(dt);
            circles[i].newPosition(dt);
            circles[i].checkCollisionBorder(screenLengths);
            for (i..numCircles) |j| {
                if (i == j) continue;
                circles[i].twoCirclesCollision(&circles[j]);
            }
        }

        rl.clearBackground(rl.Color.white);
        for (circles) |circle| {
            const intX: i32 = @intFromFloat(circle.position[0]);
            const intY: i32 = @intFromFloat(circle.position[1]);
            rl.drawCircle(intX, intY, circle.radius, circle.color);
        }

        //----------------------------------------------------------------------------------
    }
}
