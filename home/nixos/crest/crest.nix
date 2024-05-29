{ inputs, config, pkgs, ... }:

{
  home.username = "crest";
  home.homeDirectory = "/home/crest";

  imports =[ 
    ../../common/common.nix
    #inputs.catppuccin.homeManagerModules.catppuccin
  ];
  
  xdg.configFile."xkb" = {
    source = ./xkb;
    target = "xkb";
  };
  
  xdg.configFile."hyprland" = {
    source = ./hyprland.conf;
    target = "hypr/hyprland.conf";
  };
  
  xdg.enable = true;
  catppuccin = {
    #enable = true;
    flavour = "mocha";
    accent = "mauve";
  };

  programs.foot = {
    enable = true;
    catppuccin = {
      enable = true;
    #  flavour = "mocha";
    };
    settings = {
      main = {
        #include="/home/crest/.config/foot/catppuccin-mocha.conf"; 
        font="MesloLGS NF:style=Regular:size=10, Noto Color Emoji:size=10"; 
      };
    };
  };

  #xdg.configFile."foot/catppuccin-mocha.conf" = {
  #  source = ./foot/catppuccin-mocha.conf;
  #  target = "foot/catppuccin-mocha.conf";
  #}; 

  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      cursor.enable = true;
      gnomeShellTheme = true;
      icon.enable = true;
    #  flavour = "mocha";
      #accent = "pink";
      #tweaks = [ "black" ];
    };
  };
  
  programs.btop = {
    enable = true;
    catppuccin.enable = true;
  };
  
  programs.git = {
    enable = true;
    userEmail = "ian.lovering@crest-approved.org";
    userName = "Ian Lovering";
  };
    
  home.sessionVariables = {
    AWS_PROFILE = "Content-Admin";
  };
  
  programs.awscli = {
    enable = true;
    settings = {
      "profile Content-Admin" = {
        sso_session = "Cirrus";
        sso_account_id = "012402561313";
        sso_role_name = "AdministratorAccess";
        region = "eu-west-1";
        output = "json";
      };
      "sso-session Cirrus" = {
        sso_start_url = "https://d-93675f9fee.awsapps.com/start";
        sso_region = "eu-west-1";
        sso_registration_scopes = "sso:account:access";
      };
    };
  };
}

