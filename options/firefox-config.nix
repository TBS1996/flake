{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    preferences = {
      "browser.download.useDownloadDir" = false;
    };
    policies = {
      ExtensionSettings = {
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        # Privacy Badger:
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };

        # bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };

        # df youtube
        "dfyoutube@example.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/df-youtube/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
