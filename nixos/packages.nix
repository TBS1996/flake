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
  slack
  obsidian
  sqlitebrowser
  neovim
  helix
  
  # CLI apps
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

