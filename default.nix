{ config, lib, pkgs, ... }:
{
  imports = [
    <pi-bouncer>
  ];

  environment.systemPackages = with pkgs; [
    # add additional packages if needed
    # irssi
  ];

  users.extraUsers.root.openssh.authorizedKeys.keys = with (import ./ssh-keys.nix); [
    example
  ];

  pibouncer = {
    enable = true;
    tor.enable = true;
    port = 6697; # public facing port
  };

  # XXX: module
  system.activationScripts.setup-leds = ''
    # green ACT led
    echo none > /sys/class/leds/ACT/trigger
    # red PWR led
    echo mmc0 > /sys/class/leds/PWR/trigger
  '';

  services.znc = {
    enable = true;
    useLegacyConfig = false;
    mutable = false;  # immutable config, replaced on each update
    openFirewall = true;

    proxychains.enable = config.pibouncer.tor.enable;

    config = {
      LoadModule = [ "webadmin" "adminlog" ];
      MaxBufferSize = 500;
      Listener.l.Port = config.pibouncer.port;
      Listener.l.SSL = true;

      User.example = {
        Admin = true;
        Nick = "example";
        RealName = "example";
        AltNick = "exampleToo";
        LoadModule = [ "chansaver" "controlpanel" "sasl" ];

        MultiClients = true;
        PrependTimeStamp = true;

        Network.freenode = {
          Server = "chat.freenode.net +6697";
          LoadModule = [
            "keepnick"
          ];
          Chan = {
            "#nixos" = { Detached = false; };
            "##linux" = { Disabled = true; };
          };
        };

        Pass.password = {
          Method = "sha256";
          Hash = "e2ce303c7ea75c571d80d8540a8699b46535be6a085be3414947d638e48d9e93";
          Salt = "l5Xryew4g*!oa(ECfX2o";
        };
      };
    };
  };

  system.stateVersion = "20.03";
}
