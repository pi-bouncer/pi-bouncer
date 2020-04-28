/*
# gen key with
nix-shell -p wireguard
umask 077
mkdir -p secrets/wireguard-keys/
pushd secrets/wireguard-keys/
wg genkey > private
wg pubkey < private > public
popd
*/
{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.pibouncer.wg;
in
{
  options = {
    pibouncer.wg = {
      enable = mkEnableOption "Enable my wireguard";
      ip = mkOption {
        type = types.str;
      };
      endpoint = mkOption {
        type = types.str;
        example = "wireguard.example.org:45666";
      };
      pubkey = mkOption {
        type = types.str;
        default = "jzHK9nCUQ7lNiphj6s9zYisk4b/9TLDLJ0izi17pXT0=";
        example = "jzHK9nCUQ7lNiphj6s9zYisk4b/9TLDLJ0izi17pXT0=";
      };
      allowedIPs = mkOption {
        type = types.listOf types.str;
        default = [ "10.11.0.0/24" ];
        example = [ "10.11.0.0/24" ];
      };
    };
  };

  config = mkIf cfg.enable {
    networking.wireguard.interfaces = {
      wg0 = {
        ips = [ cfg.ip ];
        privateKey = "../secrets/wireguard-keys/private";
        peers = [
          { publicKey  = cfg.pubkey;
            allowedIPs = cfg.allowedIPs;
            endpoint   = cfg.endpoint;
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}

