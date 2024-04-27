const std = @import("std");
const r = @cImport(@cInclude("raylib.h"));

pub fn main() !void {
    r.InitWindow(1280, 720, "The Ziggelar");
    defer r.CloseWindow();

    r.SetTargetFPS(60);

    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        r.ClearBackground(r.BLUE);
        r.EndDrawing();
    }
}
