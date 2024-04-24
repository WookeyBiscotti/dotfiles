#!/usr/bin/rdmd

import std;
import core.stdc.stdlib;

string getHyptCtlReply(string req)
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

struct Workspace
{
    string name;
    bool isActive;
    long windowsCount;

    string renderToYuck()
    {
        auto currClass = isActive ? "active_workspace" : "workspace";
        return format(`
            (button
                :class "%s"
                :valign "center"
                :halign "center"
                :timeout "2s"
                :onclick "`
                ~ std.path.expandTilde("~/.config/eww/hypr_set_workspace.d") ~ ` %s"
                    (overlay :valign "center"
                        (label :class "%s" :halign "center" :text "%s")
                        (label :class "workspace_windows" :text "%s" :valign "center")
                    )
            )
            `, currClass, name, currClass, name, windowsCount).replace("\n", "");
    }
}

string renderToYuck(ref Workspace[] ws)
{
    string res = `(box :halign "center" :valign "center" :class "workspaces" `;
    foreach (w; ws)
    {
        res ~= w.renderToYuck();
    }
    res ~= ")";

    return res;
}

void writelnWorkspaces()
{
    auto activeworkspace = parseJSON(getHyptCtlReply("activeworkspace"))["id"].integer;
    auto workspaces = parseJSON(getHyptCtlReply("workspaces"));

    Workspace[] ws;
    foreach (size_t index, ref JSONValue w; workspaces.array)
    {
        ws ~= Workspace(
            w["name"].str,
            w["id"].integer == activeworkspace,
            w["windows"].integer);
    }
    writeln(renderToYuck(ws));
    stdout.flush();
}

void main()
{
    writelnWorkspaces();

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
        if (requestType == "workspace" || requestType == "createworkspace" || requestType == "destroyworkspace" ||
            requestType == "openwindow" || requestType == "closewindow" || requestType == "movewindow" ||
            requestType == "renameworkspace" || requestType == "activewindow")
        {
            writelnWorkspaces();
        }
    }
}
