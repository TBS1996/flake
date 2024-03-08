{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      #<home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos";


  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.utf8";

  programs.sway.enable = true;
  services.xserver.enable = false;


  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tor = {
    isNormalUser = true;
    description = "Tor";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
	tdesktop
	librewolf
	whatsapp-for-linux
	blueman
	discord
	thunderbird
	obsidian
	vscode
	tor-browser

	#cli
	helix
	tree
	mpd
	ncmpcpp
	python3
	feh
	cron
	wdisplays
	youtube-dl
	mpv
	neofetch
	htop
	bat
	bashmount
	ncdu
	fzf
	newsboat
	gcc
	cmake
	github-cli
	dmenu
	git
	wlsunset
	brightnessctl
	acpi
	cargo

	#terminal stuff
	alacritty
	tmux
	fish

	#bg
	rust-analyzer
	lldb
	swaylock
	xdg-utils
	go

    ];

  };


  nixpkgs.overlays = [
    (self: super: {
      neovim = super.neovim.override {
        viAlias = true;
        vimAlias = true;
      };
    })
  ];



  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
