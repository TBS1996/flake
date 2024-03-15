#! /nix/store/xl6mxfpj2869xbr6l6j060yay55rscd9-system-path/bin/bash



export git="/nix/store/fw5z80q6sjhf140zdkp817bd7r9xbaql-home-manager-path/bin/git /nix/store/xl6mxfpj2869xbr6l6j060yay55rscd9-system-path/bin/git"

# Navigate to your notes directory
cd /home/tor/velv/

git add .
git commit -m "auto-commit"
git push

