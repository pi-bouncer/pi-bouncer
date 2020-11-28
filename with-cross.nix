{ config, pkgs, lib, ... }:
{
  imports = [
    ./example.nix
  ];

  nixpkgs.crossSystem = {
    system = "armv7l-linux";
  };
}
