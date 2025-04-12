{
  pkgs,
  helix,
  ...
}: let
  helixTheme = import ./mytheme.nix;
in {
  programs.helix = {
    enable = true;
    package = helix.packages.${pkgs.system}.helix;

    themes = helixTheme;

    settings = {
      theme = "mytheme";

      editor = {
        soft-wrap.enable = true;
        line-number = "relative";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
    };

    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.alejandra}/bin/alejandra";
      }
    ];
  };
}
