const std = @import("std");
const io = std.io;
const reader = std.fs.File.reader;
const print = std.debug.print;
const tokenizeSequence = std.mem.tokenizeSequence;

const BUF_SIZE = std.mem.page_size;

pub fn main() !void {
    const cpuinfo_file = try std.fs.openFileAbsolute("/proc/cpuinfo", .{ .mode = .read_only });

    defer cpuinfo_file.close();

    var buf: [BUF_SIZE]u8 = undefined;

    var buf_reader = io.bufferedReader(reader(cpuinfo_file));

    var in_stream = buf_reader.reader();

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        //print("{s}\n", .{line});
        var tokens_iterator = tokenizeSequence(u8, line, ": ");
        while (tokens_iterator.next()) |token| {
            print("{s}", .{token});
        }
        print("\n", .{});
    }
}
