{ pkgs, ... }:

{
  systemd.services.commitNotes = {
    description = "Write current date and time to a file";
    serviceConfig = {
      ExecStart = "/home/tor/flake/scripts/commit_notes.sh";
      Type = "oneshot";
      User = "tor"; # Ensure this is the correct user
      Environment = "PATH=${pkgs.lib.makeBinPath [ pkgs.git pkgs.coreutils ]}";
    };
  };

  systemd.timers.commitNotes = { 
    description = "Timer for Write Date service";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/1"; # Trigger every minute
      Persistent = true;
    };
  };
}

