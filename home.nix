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
  };
in

{
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
        shellAliases = {
            actually = "echo actually using nixos fr";
        };
        profileExtra = ''
          if uwsm check may-start; then
              exec uwsm start hyprland-uwsm.desktop
          fi
        '';
    };

    
    xdg.configFile = builtins.mapAttrs (name: repoPath: {
      source = link repoPath;
    }) xdgConfigs;

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

      # --- Formatters ---
      stylua            # Lua formatter
      prettierd         # JS/TS/HTML formatter (daemon version)
      ruff              # Python formatter/linter (extremely fast)

      # --- Linters ---
      eslint_d          # JS/TS linter (daemon version)
      selene            # Lua linter (faster than luacheck)

      # --- LSP Servers ---
      lua-language-server          # Lua
      typescript-language-server   # JS/TS
      tailwindcss-language-server  # Tailwind
      vscode-langservers-extracted # Provides JSON, HTML, and CSS LSPs (replaces json-lsp)
      nixfmt

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
      
      # Archives & Files
      zip
      unzip

      (pkgs.writeShellApplication {
         name = "ns";
         runtimeInputs = with pkgs; [
            fzf
            nix-search-tv
         ];
	       checkPhase = "";
         text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
      })
   ];
}
