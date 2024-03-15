#!/usr/bin/env bash

exec > /tmp/commitNotes.log 2>&1
set -x

# Your script's contents here


# Navigate to your notes directory
cd /home/tor/velv/

git add .
git commit -m "auto-commit"
git push

