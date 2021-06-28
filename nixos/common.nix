{ config, pkgs, ... }:

{
  # Networking
  networking.networkmanager.enable = true;
  networking.enableIPv6 = true;
  networking.extraHosts =
    ''
      127.0.0.1 containers.localhost
      ::1 containers.localhost
    '';

  # Configure GRUB 
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };

    grub = {
      enable = true;
      version = 2;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
      useOSProber = true;
      enableCryptodisk = true;
    };
  };

  boot.plymouth.enable = true;

  # tmp on tmpfs
  boot.tmpOnTmpfs = true;
  
  # Add Kernel modules
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "it";
  };
  time.timeZone = "Europe/Rome";

  # OpenDoas
  security.doas = {
    enable = true;
    extraRules = [
      { groups = [ "wheel" ]; keepEnv = true; persist = true; }
    ];
  };

  # NTP
  services.chrony.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    bind
    wget
    vim
    neofetch
    cpufetch
    git
    docker-compose
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    plymouth
    virt-manager
    usbutils
    mailcap
    hwdata
  ];

  nixpkgs.config.allowUnfree = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
    extraConfig = "
      load-module module-switch-on-connect
    ";
  };

  # For steam
  hardware.opengl.driSupport32Bit = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "it";
  };

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable Virt Manager
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };

  # USB devices (Yubikey, Logitech receiver)
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.solaar pkgs.yubikey-personalization pkgs.libu2f-host ];

  # Accounts Service
  services.accounts-daemon.enable = true;

  # User accounts
  programs.fish.enable = true;
  users.users.shelladdicted = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "libvirtd" ];
    shell = pkgs.fish;
  };

  system.stateVersion = "21.05";
}
