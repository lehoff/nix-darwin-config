{ config, pkgs, ... }:

{

  # this is internal compatibility configuration
  # for home-manager, don't change this!
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  #

  home.username = "lehoff"; # Replace with your actual username
  home.homeDirectory = "/Users/lehoff"; # Replace with your home directory

  home.packages = with pkgs; [
    fasd
    zsh
    oh-my-zsh
    tree
    yq
    jq
    direnv
    speedtest-cli
    hub
    asdf-vm
    ghostscript
    remake
    parallel
    pdftk
    qpdf
    npins
    #poetry2nix
    poetry
    uv
    #tor-browser
    #helix
    davmail
    httpie
    bat

    libossp_uuid

    #nodePackages.mermaid-cli
    # devops
    skaffold
    #terraform
    kind
    kubectl
    nodePackages.npm
    imagemagick

    fontconfig

    coreutils # for factor

    google-cloud-sdk

    ollama

  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    history.extended = true;

    shellAliases = {
      #plantuml = "/etc/profiles/per-user/lehoff/bin/java -Djava.awt.headless=true -jar /opt/homebrew/Cellar/plantuml/1.2024.6/libexec/plantuml.jar";
      log = "/usr/bin/log";
      #docker = "/opt/homebrew/bin/podman";
    };

    initContent = ''
      eval "$(fasd --init auto)"
      eval "$(direnv hook zsh)"
    '';

    # Review prezto and pure options
    prezto = {
      enable = true;
      prompt.theme = "bart";
    };

    sessionVariables = {
      DOCKER_BUILDKIT = 1;
      ERL_AFLAGS = "-kernel shell_history enabled";
      NIX_PATH = "darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
      FZF_DEFAULT_COMMAND = "rg --files --hidden --follow";
      # https://mbcodes.hashnode.dev/hugo-and-macos
      HUGO_CACHEDIR = "~/.hugo-cache";
      GOOGLE_CLOUD_PROJECT = "singular-array-293219";
    };

  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      use_asdf() {
        source_env "$(asdf direnv envrc "$@")"
      }
    '';
  };

  services.ollama.enable = true;

  # Home Manager recommends home.sessionPath for adding directories to the general environment PATH.
  home.sessionPath = [
    "$HOME/.nix-profile/bin" # This is the standard HM path, which is set automatically, but harmless to specify
    "$HOME/.elan/bin" # Added from your original PATH line
    "$HOME/.cache/rebar3/bin" # Added from your original PATH line
    "/opt/homebrew/opt/cyrus-sasl/sbin"
    "/Users/lehoff/.cache/rebar3/bin"
    "/opt/homebrew/opt/openssl@1.1/bin"
    "/opt/homebrew/bin"
    "$HOME/.elan/bin"
    "$HOME/.local/bin" # for speckit
  ];
}
