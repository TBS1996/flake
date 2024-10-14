{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      # <home-manager/nixos>
    ];

  environment.systemPackages = with pkgs; [
    # Add any system packages you need here
  ] ++ (import ./packages.nix { inherit pkgs; });


  # Bluetooth settings
  hardware.bluetooth = {
    enable = true;
  };

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

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.utf8";

  programs.zsh.enable = true;
  programs.sway.enable = true;

  services.printing.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Enable sound with PipeWire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Vulkan and video drivers for GPU support
  hardware.opengl = {
    extraPackages = [ pkgs.vulkan-loader pkgs.vulkan-tools ];  # Adds Vulkan support
  };

  # Specify your video driver here. Adjust depending on your hardware:
  # For Intel and AMD:
  services.xserver.videoDrivers = [ "intel" "amdgpu" ];  # Adjust if using Nvidia
  # For Nvidia (if you have an Nvidia GPU):
  # services.xserver.videoDrivers = [ "nvidia" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "22.05"; # Did you read the comment?
}

