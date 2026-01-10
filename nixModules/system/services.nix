{ pkgs, ... }: {
  # CachyOS kernel optimizations
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  # Display
  services.xserver.videoDrivers = [ "nvidia" ];
  services.displayManager.ly.enable = true;

  # Audio and bluetooth
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

  # Application services
  services.tailscale.enable = true;
}
