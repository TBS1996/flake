#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git

# Navigate to your notes directory
cd /home/tor/velv/

git add .
git commit -m "auto-commit"
git push

