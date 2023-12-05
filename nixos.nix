{ config, lib, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.luks.devices."luks".device = "/dev/disk/by-label/luks";
  boot.initrd.postDeviceCommands = "zfs rollback rpool/local/root@blank";
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  # fileSystems."/boot".device = "/dev/disk/by-label/boot";
  # fileSystems."/" = { fsType = "zfs"; device = "rpool/yeet"; };
  # fileSystems."/keep" = { fsType = "zfs"; device = "rpool/keep"; };
  fileSystems = let zfs_device = d: { fsType = "zfs"; device = "rpool/${d}"; }; in {
    "/boot".device = "/dev/disk/by-label/boot";
    "/" = zfs_device "local/root";
    "/nix" = zfs_device "local/nix";
    "/home" = zfs_device "safe/home";
    "/persist" = zfs_device "safe/persist";
  };
  
  swapDevices = [ ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.hostId = "4e98920d";
  networking.useDHCP = lib.mkDefault true;
  networking.firewall.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  virtualisation.virtualbox.guest.enable = true;
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  services.openssh.enable = true;
  system.stateVersion = "23.11";
  environment.systemPackages = with pkgs; [
    firefox
    git
    neovim
    tmux
    zsh
  ];
}
