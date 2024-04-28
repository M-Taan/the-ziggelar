const std = @import("std");
const r = @cImport(@cInclude("raylib.h"));

const PLAYER_STARTING_X = 100;
const PLAYER_STARTING_Y = 100;

const SCREEN_WIDTH = 1280;
const SCREEN_HEIGHT = 720;

// Our boy is a circle :)
const PLAYER_RADIUS = 30;

const Player = struct {
    position: r.Vector2,
};

const StructuralEntity = struct { position: r.Vector2, width: u16, height: u16, shouldEndGame: bool = true };

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

    var pipes = [6]StructuralEntity{ undefined, undefined, undefined, undefined, undefined, undefined };

    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });

    const rand = prng.random();

    for (1..6, 0..) |pipe, index| {
        if (pipe % 2 == 0) {
            continue;
        }
        const pipeOffset: f32 = @floatFromInt(pipe);
        const pipeHeight = rand.intRangeLessThan(u16, 250, 300);
        pipes[index] = StructuralEntity{
            .position = r.Vector2{ .x = PLAYER_STARTING_X + (100 * pipeOffset), .y = 0 },
            .width = 100,
            .height = pipeHeight,
        };
        pipes[index + 1] = StructuralEntity{
            .position = r.Vector2{ .x = PLAYER_STARTING_X + (100 * pipeOffset), .y = @floatFromInt(SCREEN_HEIGHT - pipeHeight) },
            .width = 100,
            .height = pipeHeight,
        };
    }

    r.DrawRectangle(400, 400, 100, SCREEN_HEIGHT / 2, r.BLUE);

    while (!r.WindowShouldClose()) {
        r.BeginDrawing();
        r.ClearBackground(r.BLACK);

        r.DrawCircle(@intFromFloat(player.position.x), @intFromFloat(player.position.y), PLAYER_RADIUS, r.WHITE);

        for (pipes) |pipe| {
            r.DrawRectangle(@intFromFloat(pipe.position.x), @intFromFloat(pipe.position.y), pipe.width, pipe.height, r.BLUE);
        }

        _ = simulateGravity(&player);

        _ = listenToPlayerInput(&player);

        r.EndDrawing();
    }
}
