{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  environment.systemPackages = with pkgs; [
  ] ++ (import ./packages.nix { inherit pkgs; });

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.supportedFilesystems = [ "ntfs" ];

  users.users.tor = {
    isNormalUser = true;
    description = "Tor";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.variables = {
    ZDOTDIR = "/home/tor/.config/zsh";
    CARGO_HOME = "/home/tor/.cache/cargo/";
    EDITOR = "nvim";
    MESA_VK_DEVICE_SELECT = "auto";  # Automatically select the right GPU
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;
  programs.sway.enable = true;

  services.printing.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa ];  # Enable mesa driver for Vulkan support
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}

