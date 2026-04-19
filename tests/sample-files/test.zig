// test.zig — Verify: zig-mode, 4-space indent, no tabs
const std = @import("std");

const Point = struct {
    x: f64,
    y: f64,

    fn distance(self: Point, other: Point) f64 {
        const dx = self.x - other.x;
        const dy = self.y - other.y;
        return @sqrt(dx * dx + dy * dy);
    }
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const origin = Point{ .x = 0, .y = 0 };
    const target = Point{ .x = 3, .y = 4 };
    const dist = origin.distance(target);
    try stdout.print("Distance: {d:.2}\n", .{dist});
}
