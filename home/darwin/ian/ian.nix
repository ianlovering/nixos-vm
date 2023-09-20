{ config, pkgs, lib, ... }:

{
  home.username = "ian";
  home.homeDirectory = lib.mkForce "/Users/ian";

  imports =[ ../../common/common.nix ];
}

