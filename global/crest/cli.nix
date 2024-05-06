{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    freerdp
    
    nodePackages.bash-language-server
    nodePackages.pyright
    ansible-language-server
    lua-language-server

    nodePackages.prettier
    nodePackages.eslint_d
    stylua    
  ];
 
   programs.zsh = {
    enable = true;
    enableCompletion = false;
    ohMyZsh.enable = false;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      catppuccin
      vim-tmux-navigator
    ];
    extraConfig = ''
      set -g @catppuccin_user "on"
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  environment.variables.EDITOR = "nvim";
  
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;

}
