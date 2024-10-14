{ pkgs }:

with pkgs; [
  # GUI apps
  firefox
  tdesktop
  whatsapp-for-linux
  tor-browser
  zathura
  calibre
  element-desktop
  kdenlive
  obs-studio
  gimp
  xfce.thunar
  vscode
  neovim
  steam
  zed-editor
  
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
  cargo
  pamixer
  aerc
  yazi
  wl-clipboard
  fish
  syncthing
  zip
  brightnessctl
  
  # Background utilities
  rustup
  rust-analyzer
  rustfmt
  lldb
  swaylock
  xdg-utils
  openssl
  pkg-config
  rustc
  gcc
  slurp
  vulkan-loader  
  vulkan-tools
  mesa
  intel-media-driver
]

