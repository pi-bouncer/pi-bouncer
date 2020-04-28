{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.pibouncer.ntp;
in
{
  options = {
    pibouncer.ntp = {
      enable = mkEnableOption "Enable Chrony NTP daemon";
      public = mkOption {
        type = types.bool;
        default = false;
        description = "Expose as public NTP server";
      };
    };
  };

  config = mkIf cfg.enable {

    services.chrony = {
      enable = true;
      extraConfig = ''
        ${optionalString config.pibouncer.pps.enable ''
        refclock PPS ${config.pibouncer.pps.device} refid PPS
        ''}
        ${optionalString config.pibouncer.gps.enable ''
        refclock SHM 0 refid NMEA
        ''}
        makestep 0.1 1

        ${optionalString cfg.public ''
        # Allow computers on the unrouted nets to use the server.
        allow 10/8
        allow 192.168/16
        allow 172.16/12
        ''}
      '';
    };

    networking.firewall.allowedUDPPorts = optionals cfg.public [ 123 ];
  };
}
