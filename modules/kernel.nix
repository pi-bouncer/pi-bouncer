{ config, pkgs, lib, ... }:
with lib;

{
  options = {
  };

  config = {
    boot.consoleLogLevel = lib.mkDefault 7;
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
