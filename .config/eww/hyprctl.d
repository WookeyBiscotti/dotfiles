import std;
import core.stdc.stdlib;

string getHyprCtlReply(string req)
{
    auto socket = new Socket(AddressFamily.UNIX, SocketType.STREAM);

    string his = to!string(getenv("HYPRLAND_INSTANCE_SIGNATURE"));
    auto path = "/tmp/hypr/" ~ his ~ "/.socket.sock";
    socket.connect(new UnixAddress(path));

    socket.send("j/" ~ req);

    char[8192] buffer;
    auto received = socket.receive(buffer);
    socket.close();

    return to!string(buffer[0 .. received]);
}

void listenHyprSocket(void function(char[] buffer) cb)
{
    auto socket = new Socket(AddressFamily.UNIX, SocketType.STREAM);

    string his = to!string(getenv("HYPRLAND_INSTANCE_SIGNATURE"));
    auto path = "/tmp/hypr/" ~ his ~ "/.socket2.sock";
    socket.connect(new UnixAddress(path));

    char[1024] buffer;
    while (true)
    {
        auto received = socket.receive(buffer);
        cb(buffer[0..received]);
    }
}
