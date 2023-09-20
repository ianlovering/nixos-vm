{ config, pkgs, ... }:

{
  home.username = "root";
  home.homeDirectory = "/root";

  imports = [ ../../common/common.nix ];
}
