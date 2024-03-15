{ pkgs, ... }:

{
  systemd.services.writeDate = {
    description = "Write current date and time to a file";
    serviceConfig = {
      ExecStart = "./scripts/write_date.sh";
      Type = "oneshot";
      User = "tor"; # Ensure this is the correct user
      Environment = "PATH=${pkgs.lib.makeBinPath [ pkgs.git pkgs.coreutils ]}";
    };
  };

  systemd.timers.writeDate = { 
    description = "Timer for Write Date service";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/1"; # Trigger every minute
      Persistent = true;
    };
  };
}

