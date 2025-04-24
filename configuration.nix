{ pkgs, ... }:

{
    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
        vim
        ripgrep
    ];

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Set Git commit hash for darwin-version.
    # system.configurationRevision = builtins.getEnv "GITHUB_SHA" or null;

    # Used for backwards compatibility, please read the changelog before changing.
    system.stateVersion = 5;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";

    # Other global configurations can go here
}