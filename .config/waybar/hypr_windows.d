#!/usr/bin/rdmd

import std;
import core.thread;

void main() {
    while(true) {
        writeln(
`{"text":"My module text","class":"custom-windows","alt":"qwe", "on-click":"hyprctl notify -1 10000 \"rgb(ff1ea3)\" \"Hello everyone!\""}`);
        Thread.sleep(dur!("seconds")(1));
    }
}
