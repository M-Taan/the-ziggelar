const r = @cImport(@cInclude("raylib.h"));
const std = @import("std");

pub const StructuralEntity = struct {
    position: r.Vector2,
    width: u16,
    height: u16,
    shouldEndGame: bool = true,
};

pub fn initPipes(comptime numberOfPipes: u8, minStartingPosition: u16, height: u16, seed: u64) [numberOfPipes]StructuralEntity {
    var pipes: [numberOfPipes]StructuralEntity = undefined;

    var prng = std.rand.DefaultPrng.init(seed);
    const rand = prng.random();

    for (1..numberOfPipes, 0..) |pipe, index| {
        if (pipe % 2 == 0) {
            continue;
        }
        const pipeHeight = rand.intRangeLessThan(u16, 250, 300);
        pipes[index] = StructuralEntity{
            .position = r.Vector2{ .x = @as(f32, @floatFromInt(minStartingPosition)) - (110 * @as(f32, (@floatFromInt(pipe)))), .y = 0 },
            .width = 100,
            .height = pipeHeight,
        };
        pipes[index + 1] = StructuralEntity{
            .position = r.Vector2{ .x = @as(f32, @floatFromInt(minStartingPosition)) - (110 * @as(f32, (@floatFromInt(pipe)))), .y = @floatFromInt(height - pipeHeight) },
            .width = 100,
            .height = pipeHeight,
        };
    }

    return pipes;
}
