{ pkgs }:

with pkgs; [
  # GUI apps
  firefox
  tdesktop
  whatsie
  tor-browser
  calibre
  gimp
  xfce.thunar
  vscode
  slack
  obsidian
  sqlitebrowser
  neovim
  helix
  cowsay
  
  # CLI apps
  libnotify
  ripgrep
  git
  tree
  mpd
  ncmpcpp
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
  acpi
  pamixer
  yazi
  wl-clipboard
  fish
  syncthing
  zip
  brightnessctl
  gurk-rs
  zellij
  
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

