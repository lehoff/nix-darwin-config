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

Once installed:

```
darwin-rebuild switch --flake ./\#mimer
```

# home-manager

From
```
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
```

Then it has to be added to darwin.nix

# Update versions

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
