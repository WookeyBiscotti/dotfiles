#!/usr/bin/rdmd

import std;
import hyprctl;

void main() {
    listenHyprSocket((const char[] buffer) {
        string msg = to!string(buffer).findSplitBefore("\n")[0];
        auto split = msg.findSplitBefore(">>");
        auto requestType = split[0];
        if (requestType == "activewindow") {
            JSONValue js;
            js["active_window"] = msg.findSplitAfter(",")[1];
            writeln(js.toString);
            stdout.flush();
        }
    });
}
