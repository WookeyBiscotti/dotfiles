#!/usr/bin/rdmd

import hyprctl;

import std;

string currLayout() {
    try {
        auto kbs = parseJSON(getHyprCtlReply("devices"))["keyboards"];
        foreach (size_t i, ref JSONValue k; kbs.array) {
            if (k["main"].boolean) {
                return k["active_keymap"].str;
            }
        }
    } catch (Error) {
    }
    return "null";
}

void main() {
    writeln(currLayout());
    stdout.flush();

    listenHyprSocket((const char[] buffer) {
        string msg = to!string(buffer).findSplitBefore("\n")[0];
        auto split = msg.findSplitBefore(">>");
        auto requestType = split[0];
        if (requestType == "activelayout") {
            writeln(split[1].findSplitAfter(",")[1]);
            stdout.flush();
        }
    });
}
