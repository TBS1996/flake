{ pkgs, ... }:

{


  systemd.user.services.clone-velv = {
    Unit = {
      Description = "Ensure velv repo is cloned and up-to-date";
      After = [ "network.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '
        target=\"$HOME/velv\"
        if [ -d \"$target/.git\" ]; then
          git -C \"$target\" pull
        else
          git clone https://github.com/tbS1996/velv \"$target\"
        fi
      '";
      RemainAfterExit = true;
    };
  };


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

