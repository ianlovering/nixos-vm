{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs = { self, nixpkgs, hyprland, picker, home-manager }:
  outputs = { self, nixpkgs, nix-darwin, hyprland, home-manager } @inputs :
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
          hyprland.nixosModules.default
          { programs.hyprland.enable = true; }
          ./global/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ian = import ./home/nixos/ian/ian.nix;
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
