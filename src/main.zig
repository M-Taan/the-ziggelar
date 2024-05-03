const std = @import("std");
const r = @cImport(@cInclude("raylib.h"));
const pp = @import("pipes.zig");

const PLAYER_STARTING_X = 100;
const PLAYER_STARTING_Y = 100;

const SCREEN_WIDTH = 1280;
const SCREEN_HEIGHT = 720;

const NUMBER_OF_PIPES = 10;

// Our boy is a circle :)
const PLAYER_RADIUS = 30;

const Player = struct {
    position: r.Vector2,
};

fn simulateGravity(player: *Player) void {
    if (player.position.y > SCREEN_HEIGHT) {
        player.position.y = SCREEN_HEIGHT - PLAYER_RADIUS;
        return;
    }

    if (player.position.y != SCREEN_HEIGHT - PLAYER_RADIUS and !r.IsKeyPressed(r.KEY_SPACE)) {
        player.position.y = player.position.y + 7;
    }
}

fn listenToPlayerInput(player: *Player) void {
    if (r.IsKeyPressed(r.KEY_SPACE) or r.IsMouseButtonPressed(r.MOUSE_LEFT_BUTTON)) {
        player.position.y = player.position.y - 60;
    }
}

pub fn main() !void {
    r.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "The Ziggelar");
    defer r.CloseWindow();

    r.SetTargetFPS(60);

    var player = Player{ .position = r.Vector2{ .x = PLAYER_STARTING_X, .y = PLAYER_STARTING_Y } };

    var pipes: [NUMBER_OF_PIPES]pp.StructuralEntity = pp.initPipes(NUMBER_OF_PIPES, SCREEN_WIDTH, SCREEN_HEIGHT, 10000000);

    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        r.ClearBackground(r.BLACK);

        r.DrawCircle(@intFromFloat(player.position.x), @intFromFloat(player.position.y), PLAYER_RADIUS, r.WHITE);

        for (pipes, 0..) |pipe, index| {
            r.DrawRectangle(@intFromFloat(pipe.position.x), @intFromFloat(pipe.position.y), pipe.width, pipe.height, r.BLUE);
            pipes[index].position.x -= 2;

            if (pipes[index].position.x < -100) {
                pipes[index].position.x = SCREEN_WIDTH;
            }
        }

        _ = simulateGravity(&player);

        _ = listenToPlayerInput(&player);

        r.EndDrawing();
    }
}
