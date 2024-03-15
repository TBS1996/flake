#! /nix/store/xl6mxfpj2869xbr6l6j060yay55rscd9-system-path/bin/bash



export PATH="/nix/store/fw5z80q6sjhf140zdkp817bd7r9xbaql-home-manager-path/bin:/nix/store/xl6mxfpj2869xbr6l6j060yay55rscd9-system-path/bin:$PATH"


# Navigate to your notes directory
cd /home/tor/velv/

git add .
git commit -m "auto-commit"

# Attempt to push up to 5 times with a delay
for i in {1..3}; do
    git push && break || sleep 1
done
