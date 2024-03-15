{ pkgs, ... }:

let
  writeDateScript = pkgs.writeShellScriptBin "write_date" ''
    #!/bin/sh
    echo "The current date and time: $(date)" >> /home/tor/date_log.txt
  '';
in
{
  systemd.services.writeDate = {
    description = "Write current date and time to a file";
    serviceConfig = {
      ExecStart = "${writeDateScript}/bin/write_date";
      Type = "oneshot";
      User = "tor"; # Ensure this is the correct user
    };
  };

  systemd.timers.writeDate = { # Ensure this matches the service's name with 'Timer' postfix removed
    description = "Timer for Write Date service";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/1"; # Trigger every minute
      Persistent = true; # Catch up on missed triggers
    };
  };
}

