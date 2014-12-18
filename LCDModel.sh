#!/bin/sh
ioreg -lw0 -r -c "IODisplayConnect" -n "display0" -d 2 | grep IODisplayEDID | sed "/[^<]*</s///" | xxd -p -r | strings -6
