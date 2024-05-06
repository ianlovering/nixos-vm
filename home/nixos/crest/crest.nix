{ config, pkgs, ... }:

{
  home.username = "crest";
  home.homeDirectory = "/home/crest";

  imports =[ ../../common/common.nix ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        include="/home/crest/.config/foot/catppuccin-mocha.conf"; 
        font="MesloLGS NF:style=Regular:size=10, Noto Color Emoji:size=10"; 
      };
    };
  };

  xdg.configFile."foot/catppuccin-mocha.conf" = {
    source = ./foot/catppuccin-mocha.conf;
    target = "foot/catppuccin-mocha.conf";
  }; 

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "mocha";
      };
    };
  };
}

