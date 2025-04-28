{ config, pkgs, ... }:

{

    # this is internal compatibility configuration 
    # for home-manager, don't change this!
    home.stateVersion = "24.11";



    programs.home-manager.enable = true;
    fonts.fontconfig.enable = true;


    home.username = "lehoff";  # Replace with your actual username
    home.homeDirectory = "/Users/lehoff";  # Replace with your home directory



    home.packages = with pkgs; [
        fasd
        davmail
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
        #tor-browser
        #helix
        davmail

        #nodePackages.mermaid-cli
        # devops
        docker
        skaffold
        #terraform
        kind
        kubectl
        nodePackages.npm
        imagemagick

        fontconfig

    ];

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;

        history.extended = true;

        shellAliases = {
            #plantuml = "/etc/profiles/per-user/lehoff/bin/java -Djava.awt.headless=true -jar /opt/homebrew/Cellar/plantuml/1.2024.6/libexec/plantuml.jar";
            log = "/usr/bin/log";
        };

        initExtra = ''
        PATH=/opt/homebrew/opt/cyrus-sasl/sbin:/Users/lehoff/.cache/rebar3/bin:/opt/homebrew/opt/openssl@1.1/bin:/opt/homebrew/bin:$HOME/.elan/bin:$PATH
        eval "$(fasd --init auto)"
        . ~/.asdf/plugins/dotnet-core/set-dotnet-home.zsh
        '';

        # Review prezto and pure options
        prezto = {
            enable = true;
            prompt.theme = "bart";
        };

        sessionVariables = {
            DOCKER_BUILDKIT = 1;
            ERL_AFLAGS = "-kernel shell_history enabled";
            NIX_PATH =
                "darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
            FZF_DEFAULT_COMMAND = "rg --files --hidden --follow";
            # https://mbcodes.hashnode.dev/hugo-and-macos
            HUGO_CACHEDIR= "~/.hugo-cache";
        };
    };



}