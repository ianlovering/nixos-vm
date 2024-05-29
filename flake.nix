{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-old.url = "github:NixOS/nixpkgs/c4b3e961671c8dcc66a87f0a62d82eeff789fa0d";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    catppuccin = {
      url = "github:catppuccin/nix";
    };
    
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs = { self, nixpkgs, hyprland, picker, home-manager }:
  outputs = { self, nixpkgs, nix-darwin, home-manager, catppuccin, ... } @inputs :
    let
      system = "x86_64-linux";
    in {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        # overlays = [ hyprland.overlays.default picker.overlays.default ]; 
        };
        specialArgs = { inherit inputs; };
        modules = [ 
          { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
          #catppuccin.nixosModules.catppuccin
          catppuccin.homeManagerModules.catppuccin
          { programs.hyprland.enable = true; }
          ./global/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ian = {
              imports = [
                ./home/nixos/ian/ian.nix
                catppuccin.homeManagerModules.catppuccin
              ];
            };
            home-manager.users.root = import ./home/nixos/root/root.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };

      nixosConfigurations.crest = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { 
            nix.registry.nixpkgs.flake = inputs.nixpkgs;
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
          }
          #catppuccin.nixosModules.catppuccin
          ./global/crest/configuration.nix
          ./global/crest/cli.nix
          ./global/crest/desktop.nix
          ./global/crest/aws-dev.nix
          ./global/crest/hyprland.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.crest = {
              imports = [
                ./home/nixos/crest/crest.nix
                catppuccin.homeManagerModules.catppuccin
              ];
            };
            home-manager.users.root = import ./home/nixos/root/root.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
      
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."Blacky" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ 
          { 
            nix.registry.nixpkgs.flake = inputs.nixpkgs; 
            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;
          }
          ./global/darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ian = import ./home/darwin/ian/ian.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Blacky".pkgs;
  };
}
