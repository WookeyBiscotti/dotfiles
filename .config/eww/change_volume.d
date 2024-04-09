#!/usr/bin/rdmd

import std;
void main(string[] args) {
    if (args[1] == "up") {
	    executeShell("pamixer -i 1 --allow-boost");
    } else {
	    executeShell("pamixer -d 1 --allow-boost");
    }
}
