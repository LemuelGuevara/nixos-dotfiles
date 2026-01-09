{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # --- System & Core ---
    vim
    wget
    git
    ntfs3g # File system support
    blueman # Bluetooth manager
    zip
    unzip

    # --- Development Stack ---
    gcc
    gnumake
    python3
    uv # Fast Python package manager
    rustup # Rust toolchain
    nodejs_24
    nixd # Nix Language Server
    jetbrains.idea
    neovim

    # --- Desktop & Hyprland Environment ---
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

    # --- Graphical Applications ---
    vivaldi
    ghostty
    kitty
    discord
    spotify
    mpv
    qbittorrent

    # --- Gaming ---
    heroic
    mangohud
    protonup-qt
    (steam.override { extraPkgs = pkgs: with pkgs; [ nspr nss ]; }).run

    # --- Terminal Utilities (CLI) ---
    ripgrep
    starship # Shell prompt
    tmux
    tree-sitter
    fastfetch # System info
    pfetch
    eza # Modern 'ls'
    yazi # Terminal file manager
    lazygit
    btop # Resource monitor
    nvitop # GPU monitor
    dysk # Disk info
    disktui
    bluetui
    wiremix
    rmpc # MPD client
    cava # Audio visualizer

    # --- Custom Shell Scripts ---
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [ fzf nix-search-tv ];
      checkPhase = "";
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
  ];
}
