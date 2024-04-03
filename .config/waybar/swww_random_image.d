#!/usr/bin/rdmd

import std;
void main() {
    string[] files;
    foreach(f; dirEntries(std.path.expandTilde("~/Pictures/wallpapers"), SpanMode.shallow)) {
    	files ~= f;
    }
	auto rnd = Random(unpredictableSeed);
	auto i = uniform(0, files.length, rnd);
	executeShell("swww img " ~ files[i]);
}
