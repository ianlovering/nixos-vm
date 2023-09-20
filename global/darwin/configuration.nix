# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  }; 

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-history-substring-search

    git
    jaq
    ripgrep
    jc

    nodePackages.pyright
    ansible-language-server
    lua-language-server

    nodePackages.prettier
    nodePackages.eslint_d
    stylua


    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        catppuccin.catppuccin-vsc
        ms-python.python
        ms-pyright.pyright
        eamodio.gitlens
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

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  environment.variables.EDITOR = "nvim";
  environment.pathsToLink = [ "/share/zsh" ];

} 
