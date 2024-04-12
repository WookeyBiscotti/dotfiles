#!/usr/bin/rdmd
import std;
import core.stdc.stdlib;

void main()
{
    auto socket = new Socket(AddressFamily.UNIX, SocketType.STREAM);

    string his = to!string(getenv("HYPRLAND_INSTANCE_SIGNATURE"));
    auto path = "/tmp/hypr/" ~ his ~ "/.socket2.sock";
    socket.connect(new UnixAddress(path));

    char[1024] buffer;
    while (true)
    {
        auto received = socket.receive(buffer);
        writeln(buffer[0 .. received]);
    }
}
