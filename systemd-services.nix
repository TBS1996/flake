{ pkgs, ... }:

{
  systemd.services.commitNotes = {
    description = "Regular backup of notes";
    serviceConfig = {
      ExecStart = "/home/tor/flake/scripts/commit_notes.sh";
      Type = "oneshot";
      User = "tor"; 
      Environment = "PATH=${pkgs.lib.makeBinPath [ pkgs.git pkgs.coreutils ]}";
    };
  };

  systemd.timers.commitNotes = { 
    description = "Timer for notes backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };


  systemd.services.podSync = {
    description = "Sync my podcasts";
    serviceConfig = {
      ExecStart = "/home/tor/flake/scripts/podsync.sh";
      Type = "oneshot";
      User = "tor"; 
      Environment = "PATH=${pkgs.lib.makeBinPath [ pkgs.git pkgs.coreutils ]}";
    };
  };

  systemd.timers.podSync = { 
    description = "syncing my podcasts";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}

