{ config, pkgs, lib, ... }:
with lib;

{
  imports = [
    ./gps.nix
    ./ntp.nix
    ./pps.nix
    ./tor.nix
    ./wg.nix

    ../profiles/raspberrypi.nix
  ];

  options = {
    pibouncer = {
      enable = mkEnableOption "Enable pi-bouncer gateway";

      port = mkOption {
        type = types.port;
        description = "Port used for ZNC IRC frontend and Tor hidden service (if enabled)";
        default = 6697;
      };

      develMode = mkOption {
        type = types.bool;
        description = "Use for development only to e.g. autologin root";
        default = false;
      };
    };
  };

  config = mkMerge [
    (mkIf config.pibouncer.enable {

      # enables chrony but systemd default ntp is fine in this case
      #pibouncer.ntp.enable = mkDefault true;
      services.openssh.enable = true;

      environment.systemPackages = with pkgs; [
        libgpiod
      ];
    })

    (mkIf config.pibouncer.develMode {
      services.openssh.permitRootLogin = "yes";
      services.mingetty.autologinUser = "root";

      users.extraUsers.root.initialHashedPassword = "";

      environment.systemPackages = with pkgs; [
        git
        vim
        stdenv
        stdenvNoCC
      ];

      warnings = lib.singleton ''
        Development mode enabled
      '';
    })
  ];
}
