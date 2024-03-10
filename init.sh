#!/usr/bin/env bash


FLAKE_DIR=$(pwd)
HARDWARE_CONFIG="${FLAKE_DIR}/nixos/hardware-configuration.nix"

nix-shell -p git --run "true"

# Check if Git is configured, if not, configure it
GIT_NAME=$(git config --global user.name)
GIT_EMAIL=$(git config --global user.email)

if [ -z "$GIT_NAME" ]; then
    git config --global user.name "Tor"
fi

if [ -z "$GIT_EMAIL" ]; then
    git config --global user.email "torberge@outlook.com"
fi

cp /etc/nixos/hardware-configuration.nix $HARDWARE_CONFIG
git add $HARDWARE_CONFIG
git commit -m "Add hardware-configuration for $(hostname)"
sudo nixos-rebuild switch --flake .#sys

echo "System setup completed."
