const r = @cImport(@cInclude("raylib.h"));
const constants = @import("constants.zig");
const global = @import("global.zig");

pub fn gameOverScreen(state: global.State) void {
    r.ClearBackground(r.BLACK);
    r.DrawText("Game Over", 500, constants.SCREEN_HEIGHT / 2 - 100, 60, r.RED);
    r.DrawText(r.TextFormat("Score: %02i", state.gameScore), 550, constants.SCREEN_HEIGHT / 2, 40, r.BLUE);
    r.DrawText("Press Enter to resart", 420, constants.SCREEN_HEIGHT / 2 + 100, 40, r.WHITE);
}
