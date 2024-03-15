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
      ExecStart = "/home/tor/flake/scripts/commit_notes.sh";
      Type = "oneshot";
      RemainAfterExit = true;
      User = "tor"; # Run the service as user 'tor'
    };
  };

  systemd.timers.commitNotesTimer = {
    description = "Timer for commitNotes service";
    wantedBy = [ "timers.target" ];
    partOf = [ "commitNotes.service" ];
    timerConfig = { # Ensure timerConfig is nested within commitNotesTimer
      OnCalendar = "*:0/1";
#      Persistent = true;
      Unit = "commitNotes.service"; # Explicitly specify the service unit to trigger
    };
  };
}

