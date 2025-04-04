{pkgs, ...}: {
  programs.helix = {
    enable = true;

    settings = {
      theme = "onedark";

      keys.normal."C-q" = [
        ":new"
        ":insert-output lf-pick"
        ":theme default"
        "select_all"
        "split_selection_on_newline"
        "goto_file"
        "goto_last_modified_file"
        ":buffer-close!"
        ":theme tokyonight_storm"
      ];

      editor = {
        soft-wrap.enable = true;
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
