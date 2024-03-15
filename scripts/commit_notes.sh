#!/usr/bin/env bash

# Navigate to your notes directory
cd /home/tor/velv/

nix-shell -p git
git add .
git commit -m "auto-commit"
git push 

