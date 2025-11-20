{
  description = "LeHoff's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # from https://davi.sh/til/nix/nix-macos-setup/
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    #home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nix-darwin/nixpkgs";

    # from https://github.com/zhaofengli/nix-homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    # end

  };

  outputs = inputs@{
    self, nix-darwin, nixpkgs, home-manager, nix-homebrew, homebrew-core, homebrew-cask, ...
    }:
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
        # from https://github.com/zhaofengli/nix-homebrew (A. New Installation)
        # nix-homebrew.darwinModules.nix-homebrew
        # {
        #   nix-homebrew = {
        #     # Install Homebrew under the default prefix
        #     enable = true;
        #     #autoMigrate = true; # could not deal with taps.

        #     # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
        #     enableRosetta = true;

        #     # User owning the Homebrew prefix
        #     user = "lehoff";

        #     # Optional: Declarative tap management
        #     taps = {
        #       "homebrew/homebrew-core" = homebrew-core;
        #       "homebrew/homebrew-cask" = homebrew-cask;
        #     };

        #     # Optional: Enable fully-declarative tap management
        #     #
        #     # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
        #     mutableTaps = false;

        #     #packages = {
        #       brews = [ "openssl" "d2" "cloc" "podman" "docker" ];
        #       casks = [
        #           "bettertouchtool" "controlplane" "sigmaos" "firefox"
        #           "qmk-toolbox" "ukelele" "browserosaurus" "fork"
        #           "google-drive" "telegram" "whatsapp" "zoom"
        #           "aldente" "google-chrome" "chromedriver" "raycast"
        #           "chromium"
        #         ];
        #       masApps = {
        #           Amphetamine = 937984704;
        #           Pages = 409201541;
        #           Keynote = 409183694;
        #           Numbers = 409203825;
        #           Slack = 803453959;
        #           Bitwarden = 1352778147;
        #           Bear = 1091189122;
        #           ToogleTrack = 1291898086;
        #         };
        #         #};

        #   };
        #}
        ];
      specialArgs = { inherit inputs; };
    };
  };
}
