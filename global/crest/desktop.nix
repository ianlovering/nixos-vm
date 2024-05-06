{ config, lib, pkgs, ... }:
{

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "gb";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  
  fonts.fonts = with pkgs; [
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
    
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        catppuccin.catppuccin-vsc
        ms-python.python
        ms-pyright.pyright
        eamodio.gitlens
        golang.go
        jnoortheen.nix-ide
        github.vscode-pull-request-github
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "catppuccin-vsc-icons";
          publisher = "catppuccin";
          version = "0.16.0";
          sha256 = "22f7bbaa8665ab01d72093dafebb226618ef69a9caec8e9e3622b70526aeda36";
        }
        {
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.294.0";
          sha256 = "2e7c1a9f88d3e5c43fd3299ddec9314b770085765dc2f283463ce1797d47a9fe";
        }
        {
          name = "remote-ssh";
          publisher = "ms-vscode-remote";
          version = "0.103.2023051015";
          sha256 = "0da7a534f346ecb407f1a6067d23ab891a4375e3753c656006df22544693e625";
        }
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.86.0";
          sha256 = "26c6daa087a4528da7282bbe7cd6c6961e5dd53b7f409194b975063f4e13b032";
        }
        {
          name = "yuck";
          publisher = "eww-yuck";
          version = "0.0.3";
          sha256 = "0c84e02de75a3b421faedb6ef995e489a540ed46b94577388d74073d82eaadc3";
        }
      ];
    })
  ];
  
  programs.chromium.enable = true;
 }
