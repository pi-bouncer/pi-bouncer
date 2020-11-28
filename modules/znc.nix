{ config, pkgs, lib, ... }:
with lib;

{
  services.znc = {
    enable = mkDefault true;

    # mutable config, configurable via web or controlpanel
    mutable = mkDefault true;
    openFirewall = mkDefault true;

    proxychains.enable = config.pibouncer.tor.enable;

    useLegacyConfig = false;
  };
}
