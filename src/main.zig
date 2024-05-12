const std = @import("std");
const r = @cImport(@cInclude("raylib.h"));
const pp = @import("pipes.zig");
const constants = @import("constants.zig");

const Player = struct { position: r.Vector2, radius: f32 };

var gameScore: u16 = 0;

fn simulateGravity(player: *Player) void {
    if (player.position.y > constants.SCREEN_HEIGHT) {
        player.position.y = constants.SCREEN_HEIGHT - player.radius;
        return;
    }

    if (player.position.y != constants.SCREEN_HEIGHT - player.radius and !r.IsKeyPressed(r.KEY_SPACE)) {
        player.position.y = player.position.y + 4;
    }
}

fn listenToPlayerInput(player: *Player) void {
    if (r.IsKeyPressed(r.KEY_SPACE) or r.IsMouseButtonPressed(r.MOUSE_LEFT_BUTTON)) {
        player.position.y = player.position.y - 40;
    }
}

fn checkForCollision(player: Player, pipes: [constants.NUMBER_OF_PIPES]pp.PipeStructure) void {
    for (pipes) |pipe| {
        const pipeRec: r.Rectangle = r.Rectangle{
            .x = pipe.position.x,
            .y = pipe.position.y,
            .width = @floatFromInt(pipe.width),
            .height = @floatFromInt(pipe.height),
        };

        if (r.CheckCollisionCircleRec(player.position, player.radius, pipeRec)) {}
    }
}

fn addToScore(player: Player, pipes: [constants.NUMBER_OF_PIPES]pp.PipeStructure) void {
    for (pipes) |pipe| {
        if (player.position.x == pipe.position.x + @as(f32, @floatFromInt(pipe.width)) and pipe.isLower) {
            gameScore += 1;
            std.log.debug("score is now {}", .{gameScore});
        }
    }
}

pub fn main() !void {
    r.InitWindow(constants.SCREEN_WIDTH, constants.SCREEN_HEIGHT, "The Ziggelar");
    defer r.CloseWindow();

    r.SetTargetFPS(60);

    var player = Player{
        .position = r.Vector2{ .x = constants.PLAYER_STARTING_X, .y = constants.PLAYER_STARTING_Y },
        .radius = 20,
    };

    var pipes: [constants.NUMBER_OF_PIPES]pp.PipeStructure = pp.initPipes(constants.SCREEN_WIDTH);

    while (!r.WindowShouldClose()) {
        r.BeginDrawing();

        r.ClearBackground(r.BLACK);

        r.DrawCircle(@intFromFloat(player.position.x), @intFromFloat(player.position.y), player.radius, r.WHITE);

        pp.drawPipes(&pipes);

        simulateGravity(&player);

        listenToPlayerInput(&player);

        checkForCollision(player, pipes);

        addToScore(player, pipes);

        r.EndDrawing();
    }
}
