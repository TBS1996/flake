{
  pkgs,
  helix,
  ...
}: {
  programs.helix = {
    enable = true;
    package = helix.packages.${pkgs.system}.helix;

    settings = {
      theme = "onedark";

      keys.normal = {
        C-q = [":new" ":insert-output ~/.local/bin/yazi-pick" "split_selection_on_newline" "goto_file" "goto_last_modification" "goto_last_modified_file" ":buffer-close!" ":theme nord" ":theme default"];

        C-f = [":new" ":insert-output ~/.local/bin/lf-pick" "split_selection_on_newline" "goto_file" "goto_last_modification" "goto_last_modified_file" ":buffer-close!" ":theme nord" ":theme default"];
      };
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
