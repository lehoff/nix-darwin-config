{ config, pkgs, ... }:

{
    # this is internal compatibility configuration 
    # for home-manager, don't change this!
    home.stateVersion = "24.11";

    programs.home-manager.enable = true;

    home.username = "lehoff";  # Replace with your actual username
    home.homeDirectory = "/Users/lehoff";  # Replace with your home directory

    home.packages = with pkgs; [
        fasd
        davmail
        zsh
        oh-my-zsh
    ];

    programs.zsh.enable = true;
    programs.zsh.oh-my-zsh.enable = true;  # Example for Oh My Zsh
}