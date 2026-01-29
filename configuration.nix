{ pkgs, ... }:

{
  time.timeZone = "Europe/Copenhagen";

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    ripgrep
    nix-search
    plantuml
    stockfish
    geckodriver
    wget
    gtypist
    mas
    docker
    karabiner-elements
    iterm2
    skim
    dash
    logseq
    inkscape
    #gimp # did not work with 25.11 on Tahoe on 2026-01-13
    #chromedriver
    maccy
    openssl
    zed-editor
    nil # Nix LS
    nixd
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
