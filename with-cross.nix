{ config, pkgs, lib, ... }:
{
  imports = [
    ./default.nix
  ];

  nixpkgs.crossSystem = {
    system = "armv7l-linux";
  };
}
