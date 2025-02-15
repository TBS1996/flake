#!/bin/bash

target="$HOME/velv"

if [ -d "$target/.git" ]; then
    git -C "$target" pull
else
    git clone https://github.com/tbS1996/velv "$target"
fi

