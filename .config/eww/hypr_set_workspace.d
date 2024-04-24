#!/usr/bin/rdmd

import hyprctl;

import std;
import core.stdc.stdlib;


void main(string[] args)
{
    writeln(getHyprCtlReply("dispatch workspace " ~ args[1]));
}
