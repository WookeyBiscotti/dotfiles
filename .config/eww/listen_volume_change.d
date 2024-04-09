#!/usr/bin/rdmd
import std;

void main()
{
    writeln(`{"val":` ~ executeShell("pamixer --get-volume").output[0 .. $ - 1] ~ "}");
    stdout.flush();

    auto p = std.process.pipe();
    auto pactl = spawnProcess(["pactl", "subscribe"], stdin, p.writeEnd);

    while (true)
    {
        p.readEnd.byChunk(1024);

        writeln(`{"val":` ~ executeShell("pamixer --get-volume").output[0 .. $ - 1] ~ "}");
        stdout.flush();
    }

    wait(pactl);
}
