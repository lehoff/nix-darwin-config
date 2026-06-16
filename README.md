# Use Lix

# Install darwin-nix

https://github.com/nix-darwin/nix-darwin

# enable experimental features

https://stackoverflow.com/questions/74833485/how-to-use-an-experimental-command-in-nix

For permanent effect add following line to your configuration file "~/.config/nix/nix.conf"

```
extra-experimental-features = nix-command flakes
```

Could not get that to work, so…

```
nix --extra-experimental-features "nix-command flakes" flake init -t nix-darwin/nix-darwin-24.11
```

# rebuild

```
nix --extra-experimental-features "nix-command flakes" run nix-darwin/nix-darwin-24.11#darwin-rebuild -- switch
```

Once installed, use the `rebuild` script in this repo instead of calling `darwin-rebuild` directly:

```
./rebuild
```

## Why the rebuild script?

The Homebrew tap inputs (`homebrew-core`, `homebrew-cask`) are pinned in `flake.lock`. Homebrew's JSON API format changes over time, and if the pinned tap data gets too far out of date relative to the brew binary, cask installs will silently fail with a cryptic Ruby error (`undefined method 'first' for nil`). There is no pre-flight check that catches this — it only blows up during the actual install.

The `rebuild` script avoids this by refreshing those two inputs before every switch:

```
nix flake update homebrew-core homebrew-cask nix-darwin
sudo darwin-rebuild switch --flake .#mimer --impure
```

# home-manager

From
```
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
```

Then it has to be added to darwin.nix

# Upgrade to a new NixOS release

When a new NixOS release is available (e.g. 25.11 → 26.05), update the three branch references in `flake.nix`:

```
nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
home-manager.url = "github:nix-community/home-manager/release-26.05";
```

Then run:

```
nix flake update
./rebuild
```

# Update versions (within a release)

```
nix flake update
```

Might need to do this:

```
# Delete unreachable paths from the Nix store
nix-store --gc
# Delete old profile generations (optional, but good practice)
nix-collect-garbage -d
```

Update the unstable channel:
```
nix flake update nixpkgs-unstable
```

## Zed
Remember to run `cli: install binary` inside Zed after each update.
