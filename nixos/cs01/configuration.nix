{ config, pkgs, ... }:

{
  imports =
    [
      # Include common configuration
      ../common.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixos-hardware/common/pc/laptop>
      <nixos-hardware/common/cpu/intel>
    ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Networking
  networking.hostName = "cs01"; # Define your hostname
  networking.interfaces.wlo1.useDHCP = true;

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    config = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;
  hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];

  # Power management
  services.tlp.enable = true;
  powerManagement.powertop.enable = true;

  # Use the Intel drivers
  services.xserver.videoDrivers = [ "intel" ];

  services.autorandr.enable = true;

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    additionalOptions = ''MatchIsTouchpad "on"'';
  };

  boot.blacklistedKernelModules = lib.mkDefault [ "radeon" "amdgpu" ];
  services.xserver.videoDrivers = lib.mkDefault [ "intel" ];
}
