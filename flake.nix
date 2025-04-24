{
  description = "LeHoff's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # from https://davi.sh/til/nix/nix-macos-setup/
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = import ./configuration.nix;
    darwinConfig = import ./darwin.nix;
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mimer
    darwinConfigurations."mimer" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
        darwinConfig
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lehoff = import ./home.nix;
        } 
        ];
      specialArgs = { inherit inputs; };
    };
  };
}
