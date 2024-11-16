{ config, lib, pkgs, ... }:
{

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
  
  programs.hyprland.enable = true;
  #programs.hyprland.package = pkgs.hyprland.override {debug = true;};
  
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;   
  };
  
  environment.systemPackages = with pkgs; [
    waybar
    dunst
    libsForQt5.polkit-kde-agent
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    rofi
    hypridle
    hyprlock
    brightnessctl
  ];
  
  fonts.packages = with pkgs; [
    font-awesome
    meslo-lgs-nf
    jost
    roboto
    material-design-icons
    jetbrains-mono
  ];
  
}
