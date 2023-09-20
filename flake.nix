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
            home-manager.users.ian = import ./ian/ian.nix;
            home-manager.users.root = import ./root/root.nix;

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
            # List packages installed in system profile. To search by name, run:
            # $ nix-env -qaP | grep wget
            environment.systemPackages =
              [ 
              ];
            
            nix.registry.nixpkgs.flake = inputs.nixpkgs; 
            
            # Auto upgrade nix package and the daemon service.
            services.nix-daemon.enable = true;
            # nix.package = pkgs.nix;

            # Necessary for using flakes on this system.
            nix.settings.experimental-features = "nix-command flakes";

            # Create /etc/zshrc that loads the nix-darwin environment.
            programs.zsh.enable = true;  # default shell on catalina
            # programs.fish.enable = true;

            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;

            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            system.stateVersion = 4;

            services.yabai.enable = true;

            # The platform the configuration will be used on.
            nixpkgs.hostPlatform = "aarch64-darwin";
          }
          ./global/darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ian = import ./home/darwin/ian.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Blacky".pkgs;
  };
}
