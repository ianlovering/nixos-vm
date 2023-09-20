{ config, pkgs, ... }:

{
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    enableSyntaxHighlighting = false;

    shellAliases = {
      ip = "ip --color";
      vim = "nvim";
      vi = "nvim";
    };

    history = {
      ignoreDups = true;
      share = true;
    };

    oh-my-zsh = {
      enable = true;
      # plugins = [ "colored-man-pages" ];
    };

    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.config/powerlevel10k/p10k.zsh ]] || source ~/.config/powerlevel10k/p10k.zsh
    '';

    initExtra = ''
      # Terminal integration
      function osc7 {
        local LC_ALL=C
        export LC_ALL

        setopt localoptions extendedglob
        input=( ''${(s::)PWD} )
        uri=''${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%''${(l:2::0:)''$(([##16]#match))}}
        print -n "\e]7;file://''${HOSTNAME}''${uri}\e\\"
      }
      add-zsh-hook -Uz chpwd osc7

      # setup prompt
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme;

      # load and configure syntax highlighting and the history search
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      bindkey '^[OA' history-substring-search-up
      bindkey '^[OB' history-substring-search-down
      typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=yellow,fg=black,bold'
      typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=black,bold'

      # configure colours for man pages
      #less_termcap[mb]="''${fg_bold[blue]}"
      #less_termcap[md]="''${fg_bold[blue]}"
      #less_termcap[so]="''${fg_bold[black]}''${bg[yellow]}"
      #less_termcap[us]="''${fg_bold[magenta]}"

    '';
  };

  xdg.configFile."powerlevel10k" = {
    source = ./p10k.zsh;
    target = "powerlevel10k/p10k.zsh";
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      plenary-nvim
      vim-tmux-navigator
      vim-surround
      vim-ReplaceWithRegister
      comment-nvim
      nvim-tree-lua
      lualine-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      nvim-cmp
      cmp-buffer
      cmp-path
      luasnip
      friendly-snippets
      cmp_luasnip
      nvim-lspconfig
      cmp-nvim-lsp
      nvim-web-devicons
      lspsaga-nvim
      lspkind-nvim
      null-ls-nvim
      nvim-treesitter.withAllGrammars
      nvim-autopairs
      nvim-ts-autotag
      gitsigns-nvim
    ];
  };

  xdg.configFile."nvim" = {
    source = ./nvim;
    target = "nvim";
    recursive = true;
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
      set -g @catppuccin_status_modules "application directory session user host date_time battery"
    '';
  };

  programs.vscode = {
    enable = true;
    userSettings = {
      "catppuccin.accentColor" = "blue";
      "editor.fontFamily" = "'MesloLGS NF', 'monospace', monospace";
      "extensions.autoCheckUpdates" = false;
      "update.mode" = "none";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-mocha";
      "workbench.preferredDarkColorTheme" = "Catppuccin Mocha";
    };
  };
}
