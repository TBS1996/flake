{ pkgs }:

with pkgs; [
  # GUI apps
  firefox
  tdesktop
  whatsapp-for-linux
  tor-browser
  calibre
  gimp
  xfce.thunar
  vscode
  neovim
  slack
  jetbrains.idea-community
  obsidian
  sqlitebrowser
  
  # CLI apps
  alacritty
  ripgrep
  tree
  mpd
  ncmpcpp
  python3
  feh
  cron
  wdisplays
  mpv
  fastfetch
  btop
  bat
  bashmount
  ncdu
  fzf
  newsboat
  github-cli
  dmenu
  git
  acpi
  pamixer
  aerc
  yazi
  wl-clipboard
  fish
  syncthing
  zip
  brightnessctl
  
  # Background utilities
  lldb
  swaylock
  xdg-utils
  openssl
  pkg-config
  gcc
  slurp
  vulkan-loader  
  vulkan-tools
  mesa
  intel-media-driver
  direnv
  nix-direnv
]

