{ config, lib, pkgs, ... }:
{
  imports = [
    <pi-bouncer>
    ./profiles/raspberrypi.nix
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

    rpi.enable = true;
    rpi.leds.enable = true;
  };

  services.znc.config = {
    LoadModule = [ "webadmin" "adminlog" ];
    MaxBufferSize = 500;
    Listener.l.Port = config.pibouncer.port;
    Listener.l.SSL = true;

    User.example = {
      Admin = true;
      Nick = "pi-bouncer-example";
      RealName = "https://github.com/pi-bouncer/pi-bouncer";
      AltNick = "pi-bouncer-example";
      LoadModule = [ "chansaver" "controlpanel" "sasl" ];

      MultiClients = true;
      PrependTimeStamp = true;

      Network.freenode = {
        Server = "chat.freenode.net +6697";
        LoadModule = [
          "keepnick"
        ];
        Chan = {
          "#pi-bouncer" = { };
          "#nixos" = { Disabled = true; };
          "##linux" = { Disabled = true; };
          "#znc" = { Disabled = true; };
          # "#detached-example" = { Detached = true; };
        };
      };

      # generate password with
      # nix-shell -p znc --run "znc --makepass"

      Pass.password = {
        Method = "sha256";
        Hash = "e2ce303c7ea75c571d80d8540a8699b46535be6a085be3414947d638e48d9e93";
        Salt = "l5Xryew4g*!oa(ECfX2o";
      };
    };
  };

  system.stateVersion = "21.03";
}
