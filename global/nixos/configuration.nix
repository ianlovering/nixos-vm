# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  }; 

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Stuff for VMWare guest
  virtualisation.vmware.guest = {
    enable = true;
    headless = false;
  };

  #systemd.services.vmware = {
  #  after = [ 
  #    "systemd-remount-fs.service"
  #    "systemd-tmpfiles-setup.service"
  #    "systemd-modules-load.service"
  #  ];
  #  overridestrategy = "asDropin";
  #};

  environment.etc."fuse.conf" = {
    mode = "0444";
    text = ''
      user_allow_other
      mount_max = 1000
    '';
  };
  # End VMWare

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # programs.hyprland.enable = true;

  services.pipewire.wireplumber.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;
  services.xserver.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  
  fonts.fonts = with pkgs; [
    font-awesome
    meslo-lgs-nf
    jost
    roboto
    material-design-icons
  ];

  # Explicitly enabled since GNOME will be severely broken without these.
  xdg.mime.enable = true;
  xdg.icons.enable = true;

  xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };

  environment.systemPackages = with pkgs; [
    # Hyprland
    wl-clipboard
    cliphist
    libnotify
    dunst
    xdg-utils
    eww-wayland
    bluez
    blueberry
    hyprpaper
    swaybg
    wofi
    libsForQt5.polkit-kde-agent
    libsForQt5.plasma-wayland-protocols
    wev

    gtk3.out
    gdk-pixbuf
    librsvg
    gtkmm2 # needed for vmware copy / paste

    gnome.gnome-themes-extra
    gnome.adwaita-icon-theme
    hicolor-icon-theme
    tango-icon-theme
    xfce.xfce4-icon-theme
    nixos-icons
    catppuccin-gtk

    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-history-substring-search

    pciutils
    procps
    zip
    unzip
    git
    jaq
    ripgrep
    jc
    socat
    pulseaudio
    pavucontrol
    playerctl

    nodejs
    gnumake
    gcc

    nodePackages.bash-language-server
    nodePackages.pyright
    ansible-language-server
    lua-language-server

    nodePackages.prettier
    nodePackages.eslint_d
    stylua

    foot
    udiskie
    hyprpicker
    chromium
    freerdp
    remmina

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

  programs.thunar = {
    enable = true; 
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

  programs.dconf.enable = true;
  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.file-roller.enable = true;
  programs.nm-applet.enable = true;
  programs.light.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ian = {
    isNormalUser = true;
    description = "Ian";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  services.getty.autologinUser = "ian";

  security.sudo.wheelNeedsPassword = false;

  systemd.nspawn."kali" = {
    enable = true;
    execConfig = {
      Boot = true;
    };
    networkConfig = {
      Private = false;
    };
  };

  system.stateVersion = "22.11"; # Did you read the comment?
} 
