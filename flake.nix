{
  description = "LeHoff's nix-darwin system flake";

  inputs = {
    # NixOS release version — update all three lines below when upgrading
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # from https://davi.sh/til/nix/nix-macos-setup/
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    #home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nix-darwin/nixpkgs";

    # adding unstable to get newer versions of, eg, zed-editor
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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
    homebrew-nikitabobko-tap = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
    # end

  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      ...
    }:
    let
      configuration = import ./configuration.nix;
      darwinConfig = import ./darwin.nix;
      unstablePkgs = import inputs.nixpkgs-unstable {
        system = "aarch64-darwin"; # Use your actual system architecture
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mimer
      darwinConfigurations."mimer" = nix-darwin.lib.darwinSystem {
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: {
                nodejs = prev.nodejs.overrideAttrs (oldAttrs: {
                  doCheck = false;
                  checkTarget = "";
                });
              })
            ];
          }
          inputs.nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "lehoff";
              # We will use the system brew to avoid the outdated Nix store version
              enableRosetta = true;
              taps = {
                "homebrew/homebrew-core" = inputs.homebrew-core;
                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                "nikitabobko/homebrew-tap" = inputs.homebrew-nikitabobko-tap;
              };
              mutableTaps = false;
            };
          }

          # 3. Force the environment variable into the activation script
          {
            system.activationScripts.preActivation.text = ''
              export HOMEBREW_SKIP_OR_LATER_CHECK=1
            '';
          }
          # {
          #       # This forces the variable into the activation script environment
          #       system.activationScripts.preActivation.text = ''
          #         export HOMEBREW_SKIP_OR_LATER_CHECK=1
          #       '';

          #       # This ensures the homebrew bundle command sees it
          #       home-manager.users.lehoff.home.sessionVariables = {
          #         HOMEBREW_SKIP_OR_LATER_CHECK = "1";
          #       };
          #     }
          configuration
          darwinConfig
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit unstablePkgs; };
            home-manager.users.lehoff = import ./home.nix;
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
