{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.pibouncer.rpi;
  # list all with
  # > cat /sys/class/leds/ACT/trigger
  ledTriggers = types.enum [ "none" "mmc0" "heartbeat" "cpu" ];
in
{
  options = {
    pibouncer.rpi = {
      enable = mkEnableOption "RaspberryPi tweaks";
      leds = {
        enable = mkEnableOption "configuration of rPi LEDs";
        activity = mkOption {
          type = ledTriggers;
          default = "none";
          description = "Green LED (activity) trigger";
        };
        power = mkOption {
          type = ledTriggers;
          default = "heartbeat";
          description = "Red LED (power) trigger";
        };
      };
    };
  };

  config = mkIf cfg.enable {


    system.activationScripts.setup-leds = mkIf cfg.leds.enable ''
      echo ${cfg.leds.activity} > /sys/class/leds/ACT/trigger
      echo ${cfg.leds.power} > /sys/class/leds/PWR/trigger
    '';

  };
}
