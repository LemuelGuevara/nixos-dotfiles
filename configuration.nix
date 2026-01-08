{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Automatic updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  # Automatic cleanup
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 5d";
  nix.settings.auto-optimise-store = true;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Security
  security.rtkit.enable = true;

  # Hardware
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Services
  services.getty.autologinUser = "lemuelguevara";
  services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 32;
      };
    };
  };

  services.pipewire.wireplumber.extraConfig = {
    "10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [
          "a2dp_sink"
          "a2dp_source"
          "headset_head_unit"
          "headset_audio_gateway"
        ];
      };
    };
  };

  services.tailscale.enable = true;

  # Networking
  networking.hostName = "hyprnixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Manila";

  users.users.lemuelguevara = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ tree ];
    shell = pkgs.zsh;
  };

  # Nvidia
  hardware.graphics = { enable = true; };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # Only set to true when cards are higher or equal to the RTX 20 series
    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

  };

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-mono
    nerd-fonts.atkynson-mono
    inter
  ];

  # Programs
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.zsh.enable = true;
  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall =
      true; # Open ports in the firewall for Steam Local Network Game Transfers
    package =
      pkgs.steam.override { extraPkgs = pkgs: with pkgs; [ nspr nss ]; };
  };
  programs.gamemode.enable = true;
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    gcc
    git
    blueman
    mangohud
    protonup-qt
    ntfs3g
    (steam.override { extraPkgs = pkgs: with pkgs; [ nspr nss ]; }).run

    # Kde
    kdePackages.qtsvg
    kdePackages.dolphin

    (pkgs.writeShellScriptBin "nix-rebuild" ''
      sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprnixos "$@"
    '')
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";

}

