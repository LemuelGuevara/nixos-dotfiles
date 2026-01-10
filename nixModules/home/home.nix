{ config, pkgs, ... }:

let
  dotfilesRoot = "${config.home.homeDirectory}/nixos-dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/${path}";

  xdgConfigs = {
    hypr = "config/hyprland-dotfiles/hypr";
    waybar = "config/hyprland-dotfiles/waybar";
    ghostty = "config/dotfiles/.config/ghostty";
    nvim = "config/dotfiles/.config/nvim";
    tmux = "config/dotfiles/.config/tmux";
    mpv = "config/mpv";
    rmpc = "config/rmpc";
  };

in {
  imports = [ ./mpd.nix ];

  home.username = "lemuelguevara";
  home.homeDirectory = "/home/lemuelguevara";
  home.stateVersion = "25.11";
  home.file.".zshrc".source = link "config/dotfiles/.zshrc";

  xdg.configFile =
    builtins.mapAttrs (name: repoPath: { source = link repoPath; }) xdgConfigs;

  # Programs
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Lemuel Guevara";
        email = "lemuelguevara@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = { actually = "echo actually using nixos fr"; };
  };
}
