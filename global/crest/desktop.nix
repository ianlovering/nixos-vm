{ config, lib, pkgs, inputs, ... }:
{

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "gb";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  
  fonts.packages = with pkgs; [
    font-awesome
    meslo-lgs-nf
    jost
    roboto
    material-design-icons
  ];
  
  environment.systemPackages = with pkgs; [
    foot
    guvcview
    catppuccin-gtk
    chromium
    
    (vscode-with-extensions.override {
      vscodeExtensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
        catppuccin.catppuccin-vsc
        #(catppuccin.catppuccin-vsc.override {
        #  accent = "mauve";
        #  boldKeywords = true;
        #  italicComments = true;
        #  italicKeywords = true;
        #  extraBordersEnabled = false;
        #  workbenchMode = "default";
        #  bracketMode = "rainbow";
        #  colorOverrides = {};
        #  customUIColors = {};
        #})
        catppuccin.catppuccin-vsc-icons
        #pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons
        ms-python.python
        ms-pyright.pyright
        eamodio.gitlens
        golang.go
        jnoortheen.nix-ide
        github.vscode-pull-request-github
        ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
      ];
    })
  ];
  
  programs.chromium.enable = true;
 }
