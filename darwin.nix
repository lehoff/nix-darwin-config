{ pkgs, ... }:

{
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment = {
        variables.LANG = "en_GB.UTF-8";
        #loginShell = "${pkgs.zsh}/bin/zsh -l";
        systemPackages = [
        pkgs.nodePackages.mermaid-cli
        ];
        systemPath = [
            "~/.asdf/shims"
            "~/.dotnet/tools"
        ];
    };
    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;
    #services.karabiner-elements.enable = true;
    nix.package = pkgs.nix;

    programs.nix-index.enable = true;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true;  # default shell on catalina
    # programs.fish.enable = true;
    programs.bash.enable = false;


    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";

    users.users.lehoff = {
        name = "lehoff";
        home = "/Users/lehoff";
        shell = pkgs.zsh;
    };

    



    homebrew = {
        enable = true;  
        # onActivation.cleanup = "zap"; # this leads to errors
        global = {
            brewfile = true;
            lockfiles = true;  
        };

        brews = 
        [
            "openssl" # used by erlang for crypto
        ];

        casks = 
        [
            "bettertouchtool"
            "controlplane"
            "sigmaos"
            "firefox"
            "qmk-toolbox"
            "ukelele"
            "browserosaurus"
            "fork" 
            "google-drive"
            "telegram"
            "whatsapp"
            "zoom"
            "aldente"
            "google-chrome"
            "raycast"
        ];
    masApps = {
        Amphetamine = 937984704;
        Pages = 409201541;
        Keynote = 409183694;
        Numbers = 409203825;
        Slack = 803453959;
        Bitwarden = 1352778147;
        Bear = 1091189122;
        ToogleTrack = 1291898086;
    };

    };
}