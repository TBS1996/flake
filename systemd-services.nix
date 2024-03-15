{ pkgs, lib, ... }:

let
  # Define a simple script that writes the current date and time to a file.
  writeDateScript = pkgs.writeShellScriptBin "write_date" ''
    #!/bin/sh
    echo "The current date and time: $(date)" >> /home/tor/date_log.txt
  '';
in
{
  systemd.services.writeDate = {
    description = "Write current date and time to a file";
    script = "${writeDateScript}/bin/write_date";
    serviceConfig = {
      Type = "oneshot";
      User = "tor"; # Replace 'user' with your actual username
      # No need for RemainAfterExit for a script that just writes the date
    };
  };

  systemd.timers.writeDateTimer = {
    description = "Timer for Write Date service";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/1"; # Trigger every minute
      Persistent = true; # Catch up on missed triggers
    };
  };
}

