{ config, pkgs, ... }:

{
  home.username = "ian";
  home.homeDirectory = "/home/ian";

  imports =[ ../../common/common.nix ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        include="/home/ian/.config/foot/catppuccin-mocha.conf"; 
        font="MesloLGS NF:style=Regular:size=10, Noto Color Emoji:size=10"; 
      };
    };
  };

  xdg.configFile."foot/catppuccin-mocha.conf" = {
    source = ./foot/catppuccin-mocha.conf;
    target = "foot/catppuccin-mocha.conf";
  }; 

  xdg.configFile."hyprland" = {
    source = ./hypr;
    target = "hypr";
    recursive = true;
  };

  xdg.configFile."eww" = {
    source = ./eww;
    target = "eww";
    recursive = true;
  };

  xdg.configFile."wofi" = {
    source = ./wofi;
    target = "wofi";
    recursive = true;
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

