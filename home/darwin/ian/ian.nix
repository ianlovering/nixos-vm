{ config, pkgs, lib, ... }:

{
  home.username = "ian";
  home.homeDirectory = lib.mkForce "/Users/ian";

  imports =[ ../../common/common.nix ];

  programs.git = {
    enable = true;
    # ...
    extraConfig = {
      credential = {
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      };
    };
  };
}

