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
  home.username = "lemuelguevara";
  home.homeDirectory = "/home/lemuelguevara";
  home.stateVersion = "25.11";

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
    profileExtra = ''
      if uwsm check may-start; then
          exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };

  # Services
  services.mpd = {
    enable = true;
    musicDirectory = "/home/lemuelguevara/Music";

    extraConfig = ''
      # Audio Output for PipeWire
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }

      audio_output {
        type                    "fifo"
        name                    "Visualizer feed"
        path                    "/tmp/mpd.fifo"
        format                  "44100:16:2"
      }
    '';
  };

  xdg.configFile =
    builtins.mapAttrs (name: repoPath: { source = link repoPath; }) xdgConfigs;

  home.file.".zshrc".source = link "config/dotfiles/.zshrc";

  home.packages = with pkgs; [
    # User Applications
    vivaldi
    ghostty
    kitty
    discord
    qbittorrent
    heroic
    mpv
    spotify
    jetbrains.idea

    # Desktop Environment
    waybar
    rofi
    wl-clipboard
    cliphist
    pipewire
    wireplumber
    hyprpaper
    hyprshot

    # Development Tools
    neovim
    python3
    uv
    rustup
    nodejs_24
    gcc
    nixd

    # CLI Utilities
    ripgrep
    starship
    tmux
    tree-sitter
    fastfetch
    eza
    yazi
    lazygit
    dysk
    disktui
    bluetui
    wiremix
    btop
    nvitop
    pfetch
    rmpc
    cava

    # Archives & Files
    zip
    unzip

    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [ fzf nix-search-tv ];
      checkPhase = "";
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
  ];
}
