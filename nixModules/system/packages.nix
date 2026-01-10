{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Core Utilities
    vim
    wget
    git
    ntfs3g
    blueman
    zip
    unzip
    openssl

    #  Development Tools
    gcc
    gnumake
    python3
    uv
    rustup
    nodejs_24
    nixd
    jetbrains.idea
    neovim
    dive
    podman-tui
    podman-desktop
    podman-compose
    docker-compose

    # Desktop Environment
    waybar
    rofi
    wl-clipboard
    cliphist
    pipewire
    wireplumber
    hyprpaper
    hyprshot
    kdePackages.qtsvg
    kdePackages.dolphin

    # GUI Applications
    vivaldi
    ghostty
    kitty
    discord
    spotify
    mpv
    qbittorrent

    # Gaming
    heroic
    mangohud
    protonup-qt
    (steam.override { extraPkgs = pkgs: with pkgs; [ nspr nss ]; }).run

    # CLI Utilities
    ripgrep
    starship
    tmux
    tree-sitter
    fastfetch
    pfetch
    eza
    yazi
    lazygit
    btop
    nvitop
    dysk
    disktui
    bluetui
    wiremix
    rmpc
    cava

    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [ fzf nix-search-tv ];
      checkPhase = "";
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
  ];
}
