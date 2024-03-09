#!/usr/bin/env bash

# Assuming this script is run from the flake's directory
FLAKE_DIR=$(pwd)
HARDWARE_CONFIG="${FLAKE_DIR}/nixos/hardware-configuration.nix"

# Ensure git is available
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

# Step 1: Ensure hardware-configuration.nix is in place
cp /etc/nixos/hardware-configuration.nix $HARDWARE_CONFIG

# Step 2: Git operations
git add $HARDWARE_CONFIG
git commit -m "Add hardware-configuration for $(hostname)"
# Uncomment the next line if you want to push automatically
# git push

# Step 3: NixOS rebuild with flake
sudo nixos-rebuild switch --flake .#sys

echo "System setup completed."
