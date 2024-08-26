const std = @import("std");
const rl = @import("raylib");
const rlm = @cImport("raymath.h");

const vec2 = rl.Vector2;
const cos = std.math.cos;
const sin = std.math.sin;

const GameState = struct {
    pos: vec2,
    rot: f32,
    momentum: vec2,
};

const scale = 2;

var state: GameState = undefined;

pub fn drawShape(points: []vec2) !void {
    for (0..points.len) |i| {
        rl.drawLineV(points[i], points[(i + 1) % points.len], rl.Color.white);
    }
}

pub fn drawShip(delta: f32) !void {
    state.pos = state.pos.add(state.momentum.scale(delta * 10.0));
    state.momentum = state.momentum.subtract(state.momentum.normalize().scale(delta));
    std.debug.print("X Pos: {}", .{delta});
    var points = [_]vec2{
        vec2.init(-7.5 * scale, 10 * scale),
        vec2.init(0 * scale, -10 * scale),
        vec2.init(7.5 * scale, 10 * scale),
        vec2.init(5 * scale, 7.5 * scale),
        vec2.init(-5 * scale, 7.5 * scale),
    };
    for (0..points.len) |i| {
        const x = points[i].x;
        const y = points[i].y;
        points[i] = vec2.init(x * cos(state.rot) - y * sin(state.rot), x * sin(state.rot) + y * cos(state.rot));
        points[i] = points[i].add(state.pos);
    }
    try drawShape(&points);
}

pub fn keyInputs() !void {
    if (rl.isKeyDown(rl.KeyboardKey.key_d) or rl.isKeyDown(rl.KeyboardKey.key_right)) {
        state.rot += 0.2;
    }
    if (rl.isKeyDown(rl.KeyboardKey.key_a) or rl.isKeyDown(rl.KeyboardKey.key_left)) {
        state.rot -= 0.2;
    }
    if (rl.isKeyDown(rl.KeyboardKey.key_w) or rl.isKeyDown(rl.KeyboardKey.key_up)) {
        const boost = vec2.init(cos(state.rot - (std.math.pi / 2.0)), sin(state.rot - (std.math.pi / 2.0))).scale(1);
        state.momentum = state.momentum.add(boost);
    }
}

pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800 * scale;
    const screenHeight = 450 * scale;

    rl.initWindow(screenWidth, screenHeight, "Asteroids");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------
    state.rot = 0;
    state.pos = vec2.init(screenWidth / 2, screenHeight / 2);
    state.momentum = vec2.init(1, 0);
    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        state.pos = vec2.init(@mod(state.pos.x, screenWidth), @mod(state.pos.y, screenHeight));
        const delta = rl.getFrameTime() * scale;
        try keyInputs();
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();
        try drawShip(delta);
        rl.clearBackground(rl.Color.black);
    }
}
