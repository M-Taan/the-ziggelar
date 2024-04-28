const std = @import("std");
const r = @cImport(@cInclude("raylib.h"));

const PLAYER_STARTING_X = 100;
const PLAYER_STARTING_Y = 100;

const SCREEN_WIDTH = 1280;
const SCREEN_HEIGHT = 720;

const Player = struct {
    position: r.Vector2,
};

fn simulateGravity(player: *Player) void {
    if (player.position.y > SCREEN_HEIGHT) {
        player.position.y = SCREEN_HEIGHT - 50;
        return;
    }

    if (player.position.y != SCREEN_HEIGHT - 50 and !r.IsKeyPressed(r.KEY_SPACE)) {
        player.position.y = player.position.y + 10;
    }
}

fn listenToPlayerInput(player: *Player) void {
    if (r.IsKeyPressed(r.KEY_SPACE) or r.IsMouseButtonPressed(r.MOUSE_LEFT_BUTTON)) {
        player.position.y = player.position.y - 100;
    }
}

pub fn main() !void {
    r.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "The Ziggelar");
    defer r.CloseWindow();

    r.SetTargetFPS(60);

    var player = Player{ .position = r.Vector2{ .x = PLAYER_STARTING_X, .y = PLAYER_STARTING_Y } };

    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        r.ClearBackground(r.BLACK);

        r.DrawCircle(@intFromFloat(player.position.x), @intFromFloat(player.position.y), 50, r.WHITE);

        _ = simulateGravity(&player);

        _ = listenToPlayerInput(&player);

        r.EndDrawing();
    }
}
