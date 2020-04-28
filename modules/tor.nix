{ config, pkgs, lib, ... }:
with lib;

{
  options = {
    pibouncer.tor = {
      enable = mkEnableOption "Enable TOR client";
    };
  };

  config = mkIf config.pibouncer.tor.enable {
    services.proxychains.enable = true;

    services.tor = {
      enable = true;
      client = {
        enable = true;
        dns.enable = true;
      };
      hiddenServices."pibouncer".map = [
        { port = 22; }
        { port = config.pibouncer.port; }
      ];
      extraConfig = ''
        MapAddress zettel.freenode.net ajnvpgl6prmkb7yktvue6im5wiedlz2w32uhcwaamdiecdrfpwwgnlqd.onion
      '';
    };
  };
}
