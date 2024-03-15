#!/nix/store/xl6mxfpj2869xbr6l6j060yay55rscd9-system-path/bin/bash

exec > /tmp/commitNotes.log 2>&1
set -x

# Your script's contents here


# Navigate to your notes directory
cd /home/tor/velv/

git add .
git commit -m "auto-commit"
git push

