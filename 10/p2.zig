const std = @import("std");
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;

const Point = struct {
    x: usize,
    y: usize,
    level: u8,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var grid = ArrayList(ArrayList(u8)).init(allocator);
    defer {
        for (grid.items) |row| {
            row.deinit();
        }
        grid.deinit();
    }

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var row = ArrayList(u8).init(allocator);
        for (line) |c| {
            if (c >= '0' and c <= '9') {
                try row.append(c);
            }
        }
        try grid.append(row);
    }

    var heads = ArrayList(Point).init(allocator);
    defer heads.deinit();

    for (grid.items, 0..) |row, x| {
        for (row.items, 0..) |val, y| {
            if (val == '0') {
                try heads.append(.{ .x = x, .y = y, .level = '0' });
            }
        }
    }

    var total: usize = 0;
    for (heads.items) |head| {
        var queue = ArrayList(Point).init(allocator);
        defer queue.deinit();
        try queue.append(head);

        var visited = AutoHashMap(Point, void).init(allocator);
        defer visited.deinit();

        var paths = AutoHashMap(Point, usize).init(allocator);
        defer paths.deinit();
        try paths.put(head, 1);

        var count: usize = 0;

        while (queue.items.len > 0) {
            const current = queue.orderedRemove(0);

            if (visited.contains(current)) continue;
            try visited.put(current, {});

            if (current.level == '9') {
                const val = paths.get(current).?;
                count += val;
                continue;
            }

            const directions = [_][2]i32{
                [_]i32{ 0, -1 },
                [_]i32{ -1, 0 },
                [_]i32{ 0, 1 },
                [_]i32{ 1, 0 },
            };

            for (directions) |dir| {
                const nx = @as(i32, @intCast(current.x)) + dir[0];
                const ny = @as(i32, @intCast(current.y)) + dir[1];

                if (nx < 0 or nx >= grid.items.len or ny < 0 or ny >= grid.items[0].items.len) {
                    continue;
                }

                const next_x = @as(usize, @intCast(nx));
                const next_y = @as(usize, @intCast(ny));
                const next_level = current.level + 1;

                if (grid.items[next_x].items[next_y] == next_level) {
                    const next_point = Point{ .x = next_x, .y = next_y, .level = next_level };
                    try queue.append(next_point);

                    const cur_val = paths.get(current).?;
                    const value = paths.get(next_point);
                    if (value) |v| {
                        try paths.put(next_point, cur_val + v);
                    } else {
                        try paths.put(next_point, cur_val);
                    }
                }
            }
        }

        total += count;
    }

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}\n", .{total});
}
