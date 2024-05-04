const std = @import("std");
const r = @cImport(@cInclude("raylib.h"));
const pp = @import("pipes.zig");
const constants = @import("constants.zig");

const Player = struct {
    position: r.Vector2,
};

fn simulateGravity(player: *Player) void {
    if (player.position.y > constants.SCREEN_HEIGHT) {
        player.position.y = constants.SCREEN_HEIGHT - constants.PLAYER_RADIUS;
        return;
    }

    if (player.position.y != constants.SCREEN_HEIGHT - constants.PLAYER_RADIUS and !r.IsKeyPressed(r.KEY_SPACE)) {
        player.position.y = player.position.y + 4;
    }
}

fn listenToPlayerInput(player: *Player) void {
    if (r.IsKeyPressed(r.KEY_SPACE) or r.IsMouseButtonPressed(r.MOUSE_LEFT_BUTTON)) {
        player.position.y = player.position.y - 40;
    }
}

pub fn main() !void {
    r.InitWindow(constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT, "The Ziggelar");
    defer r.CloseWindow();

    r.SetTargetFPS(60);

    var player = Player{ .position = r.Vector2{ .x = constants.PLAYER_STARTING_X, .y = constants.PLAYER_STARTING_Y } };

    var pipes: [constants.NUMBER_OF_PIPES]pp.PipeStructure = pp.initPipes(constants.SCREEN_WIDTH);

    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        r.ClearBackground(r.BLACK);

        r.DrawCircle(@intFromFloat(player.position.x), @intFromFloat(player.position.y), constants.PLAYER_RADIUS, r.WHITE);

        pp.drawPipes(&pipes);

        simulateGravity(&player);

        listenToPlayerInput(&player);

        r.EndDrawing();
    }
}
