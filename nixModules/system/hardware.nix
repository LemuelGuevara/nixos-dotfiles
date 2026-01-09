{ pkgs, ... }: {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Nvidia
  hardware.graphics = { enable = true; };

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # Only set to true when cards are higher or equal to the RTX 20 series
    open = true;

    nvidiaSettings = true;

    package = pkgs.linuxPackages_cachyos-lto.nvidiaPackages.beta;
  };
}
