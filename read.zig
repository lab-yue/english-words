const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("words.txt", .{});
    defer file.close();

    const stdout = std.io.getStdOut().writer();
    var args = std.process.args();
    _ = args.skip();

    const end = args.nextPosix() orelse "";
    const myabe_limit = std.fmt.parseInt(u64, args.nextPosix() orelse "10", 10) catch null;

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (myabe_limit) |limit| {
            if (line.len > limit) {
                continue;
            }
        }
        if (std.mem.endsWith(u8, line, end)) {
            try stdout.print("{s}\n", .{line});
        }
    }
}
