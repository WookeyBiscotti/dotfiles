#!/usr/bin/rdmd

import hyprctl;

import std;
import core.stdc.stdlib;

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
                :timeout "2s"
                :onclick "` ~ std.path.expandTilde("~/.config/eww/hypr_set_workspace.d") ~ ` %s"
                (label  
                    :class "%s"
                    :markup "%s<span baseline_shift=\"superscript\" size=\"small\">%s</span>"
                )
            )`, currClass, name, currClass, name, windowsCount).replace("\n", " ");
    }
}

string renderToYuck(ref Workspace[] ws)
{
    string res = `(box :space-evenly false :valign "center" :halign "center" :class "workspaces"`;
    foreach (w; ws)
    {
        res ~= w.renderToYuck();
    }
    res ~= ")";

    return res;
}

void writelnWorkspaces()
{
    auto activeworkspace = parseJSON(getHyprCtlReply("activeworkspace"))["id"].integer;
    auto workspaces = parseJSON(getHyprCtlReply("workspaces"));

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

    listenHyprSocket((const char[] msg) {
        auto requestType = msg.findSplitBefore(">>")[0];
        if (requestType == "workspace" || requestType == "createworkspace" || requestType == "destroyworkspace" ||
        requestType == "openwindow" || requestType == "closewindow" || requestType == "movewindow" ||
        requestType == "renameworkspace" || requestType == "activewindow")
        {
            writelnWorkspaces();
        }
    });
}
