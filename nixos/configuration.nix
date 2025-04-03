let
  vars = import ../vars.nix;
in
  {
    config,
    pkgs,
    ...
  }: {
    imports = [./hardware-configuration.nix];

    environment.systemPackages = with pkgs;
      [] ++ (import ./packages.nix {inherit pkgs;});

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.supportedFilesystems = ["ntfs"];
    boot.kernelParams = [
      "acpi_backlight=vendor"
      "kbdrate.rate=60"
      "kbdrate.delay=175"
    ];

    users.users.${vars.username} = {
      isNormalUser = true;
      description = "Tor";
      shell = pkgs.zsh;
      extraGroups = ["networkmanager" "wheel" "docker"];
    };

    system.activationScripts.cloneVelv = {
      text = ''
        sudo -u tor systemctl --user start clone-velv.service
      '';
      deps = ["users"];
    };

    console.colors = [
      "000000" # black
      "ff5555" # red
      "50fa7b" # green
      "f1fa8c" # yellow
      "bd93f9" # blue (better than the default!)
      "ff79c6" # magenta
      "8be9fd" # cyan
      "bbbbbb" # white
      "44475a" # bright black
      "ff6e6e" # bright red
      "69ff94" # bright green
      "ffffa5" # bright yellow
      "d6acff" # bright blue
      "ff92df" # bright magenta
      "a4ffff" # bright cyan
      "ffffff" # bright white
    ];

    environment.variables = {
      ZDOTDIR = "/home/tor/.config/zsh";
      CARGO_HOME = "/home/tor/.cache/cargo/";
      EDITOR = "hx";
    };

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;
    time.timeZone = "Europe/Oslo";
    i18n.defaultLocale = "en_US.UTF-8";

    programs.zsh.enable = true;
    programs.sway.enable = true;

    services.printing.enable = false;
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nixpkgs.config.allowUnfree = true;

    hardware.graphics = {
      enable = true;
      extraPackages = [pkgs.mesa];
    };

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    system.stateVersion = "22.05";
  }
