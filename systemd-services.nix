{ pkgs, ... }:

let
  commitNotesScript = pkgs.writeShellScriptBin "commit_notes" (builtins.readFile ./scripts/commit_notes.sh);
in
{
  systemd.services.commitNotes = {
    description = "Commit and push notes periodically";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      # Correctly quote the ExecStart command as a literal string
      ExecStart = "${pkgs.writeScriptBin "run-commit-notes" ''
        #!/usr/bin/env sh
        ${pkgs.git}/bin/git --version
        exec ${pkgs.bash}/bin/bash ${commitNotesScript}/bin/commit_notes
      ''}/bin/run-commit-notes";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.timers.commitNotesTimer = {
    description = "Timer for commitNotes service";
    wantedBy = [ "timers.target" ];
    partOf = [ "commitNotes.service" ];
    timerConfig = {
      OnCalendar = "*:0/1";
      Persistent = true;
    };
  };
}

