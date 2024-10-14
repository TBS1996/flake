{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  environment.systemPackages = with pkgs; [
  ] ++ (import ./packages.nix { inherit pkgs; });



  # Workaround until this hits unstable:
  # https://github.com/NixOS/nixpkgs/issues/113628
  systemd.services.bluetooth.serviceConfig.ExecStart = [
    ""
    "${pkgs.bluez}/libexec/bluetooth/bluetoothd -f /etc/bluetooth/main.conf"
  ];

  services.blueman.enable = true;

  # Bootloader.
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

  environment.variables.ZDOTDIR = "/home/tor/.config/zsh";
  environment.variables.CARGO_HOME = "/home/tor/.cache/cargo/";
  environment.variables.EDITOR = "nvim";
  environment.variables.MESA_VK_DEVICE_SELECT = "intel";


  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.utf8";

  programs.zsh.enable = true;
  programs.sway.enable = true;

  services.printing.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;


  hardware.bluetooth = {
    enable = true;
  };

  # Enable sound with PipeWire.
  hardware.pulseaudio.enable = false;


  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        vulkan-loader   
        vulkan-tools   
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
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

