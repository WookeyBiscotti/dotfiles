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
        string msg = to!string(buffer[0 .. received]).findSplitBefore("\n")[0];

        auto requestType = msg.findSplitBefore(">>")[0];
        if (requestType == "activewindow")
        {
            JSONValue js;
            js["active_window"] = msg.findSplitAfter(",")[1];
            writeln(js.toString);
            stdout.flush();
        }
    }
}
