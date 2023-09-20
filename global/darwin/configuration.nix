# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ self, config, pkgs, ... }:

{
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
 
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  services.yabai.enable = true;

  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-history-substring-search

    git
    jaq
    ripgrep
    jc
    less

    nodePackages.pyright
    ansible-language-server
    lua-language-server

    nodePackages.prettier
    nodePackages.eslint_d
    stylua

    iterm2
    utm

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
        {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.2.2";
          sha256 = "8f038cfba2e71f20a4be13935524d466f831efb8c083a845082a41a98f00c488";
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

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      font-awesome
      meslo-lgs-nf
      jost
      roboto
      material-design-icons
    ];
  };

} 
