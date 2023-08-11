{
  description = "NixOS Configuration";

  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    #picker.url = "github:hyprwm/hyprpicker";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  # outputs = { self, nixpkgs, hyprland, picker, home-manager }:
  outputs = { self, nixpkgs, hyprland, home-manager } @inputs :
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        # overlays = [ hyprland.overlays.default picker.overlays.default ]; 
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [ 
          { nix.registry.nixpkgs.flake = inputs.nixpkgs; }
          hyprland.nixosModules.default
          { programs.hyprland.enable = true; }
          ./configuration.nix
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
    };
}
