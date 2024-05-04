const r = @cImport(@cInclude("raylib.h"));
const std = @import("std");
const constants = @import("constants.zig");

var prng = std.rand.DefaultPrng.init(10000000000000000);
const rand = prng.random();

pub const PipeStructure = struct {
    position: r.Vector2,
    width: u16,
    height: u16,
    isLower: bool = false,
};

fn generatePipeHeight() u16 {
    const height = rand.intRangeLessThan(u16, constants.MIN_PIPE_HEIGHT, constants.MAX_PIPE_HEIGHT);
    return height;
}

pub fn initPipes(minStartingPosition: u16) [constants.NUMBER_OF_PIPES]PipeStructure {
    var pipes: [constants.NUMBER_OF_PIPES]PipeStructure = undefined;

    for (1..constants.NUMBER_OF_PIPES, 0..) |pipe, index| {
        if (pipe % 2 == 0) {
            continue;
        }

        const upperPipeHeight = generatePipeHeight();
        const lowerPiepHeight = generatePipeHeight();

        pipes[index] = PipeStructure{
            .position = r.Vector2{ .x = @as(f32, @floatFromInt(minStartingPosition)) - (110 * @as(f32, (@floatFromInt(pipe)))), .y = 0 },
            .width = 100,
            .height = upperPipeHeight,
        };
        pipes[index + 1] = PipeStructure{
            .position = r.Vector2{ .x = @as(f32, @floatFromInt(minStartingPosition)) - (110 * @as(f32, (@floatFromInt(pipe)))), .y = @floatFromInt(constants.SCREEN_HEIGHT - lowerPiepHeight) },
            .width = 100,
            .height = lowerPiepHeight,
            .isLower = true,
        };
    }

    return pipes;
}

pub fn drawPipes(pipes: *[constants.NUMBER_OF_PIPES]PipeStructure) void {
    for (pipes, 0..) |pipe, index| {
        r.DrawRectangle(@intFromFloat(pipe.position.x), @intFromFloat(pipe.position.y), pipe.width, pipe.height, r.BLUE);

        // move pipes towards the player
        pipes[index].position.x -= 2;

        // move pipe position to the end of screen when the pipe is offscreen
        if (pipes[index].position.x < -constants.PIPE_WIDTH) {
            pipes[index].position.x = constants.SCREEN_WIDTH;

            pipes[index].height = generatePipeHeight();

            if (pipes[index].isLower) {
                pipes[index].position.y = @floatFromInt(constants.SCREEN_HEIGHT - pipes[index].height);
            }
        }
    }
}
