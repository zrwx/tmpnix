{ inputs, config, lib, pkgs, ... }:
let
  mainuser = "u";
  hostname = mainuser;
  mainuser_password = mainuser;
  zfs_root = "zroot";
  zfs_yeet = "yeet";
  zfs_yeeted_snapshot = "${zfs_root}/${zfs_yeet}@yeeted";
  keep = "u";
  keep_rootfs_path = "/${keep}/.rootfs";
  inputrc = ''
    set editing-mode vi
    set meta-flag on
    set input-meta on
    set convert-meta off
    set output-meta on
    $if mode=vi
    set show-mode-in-prompt on
    set vi-ins-mode-string \1\e[6 q\2
    set vi-cmd-mode-string \1\e[2 q\2
    set keymap vi-command
    Control-l: clear-screen
    Control-a: beginning-of-line
    set keymap vi-insert
    Control-l: clear-screen
    Control-a: beginning-of-line
    $endif
  '';
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModule
  ];
  boot.tmp.cleanOnBoot = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;
  boot.initrd.availableKernelModules = [
     "ahci"
     "ata_piix"
     "ehci_pci"
     "nvme"
     "ohci_pci"
     "rtsx_pci_sdmmc"
     "sd_mod"
     "sr_mod"
     "usb_storage"
     "usbhid"
     "xhci_pci"
  ];
  boot.initrd.kernelModules = [
    # "i915"
    "kvm-intel"
  ];
  boot.initrd.luks.devices."luks".device = "/dev/disk/by-label/luks";
  # boot.intird.verbose = false;
  boot.initrd.postDeviceCommands = lib.mkAfter "zfs rollback ${zfs_yeeted_snapshot}";
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelModules = [
    # "kvm-intel"
    # "i915"
    # "tcp_bbr"
  ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    # "i915.enable_fbc=1"
    # "i915.enable_psr=2"
    # "log_level=0"
    # "quiet"
    # "rd.systemd.show_status=false"
    # "splash"
    # "udev.log_level=3"
  ];
  
  # boot.kernel.sysctl = {
  #   # The Magic SysRq key is a key combo that allows users connected to the
  #   # system console of a Linux kernel to perform some low-level commands.
  #   # Disable it, since we don't need it, and is a potential security concern.
  #   "kernel.sysrq" = 0;

  #   ## TCP hardening
  #   # Prevent bogus ICMP errors from filling up logs.
  #   "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
  #   # Reverse path filtering causes the kernel to do source validation of
  #   # packets received from all interfaces. This can mitigate IP spoofing.
  #   "net.ipv4.conf.default.rp_filter" = 1;
  #   "net.ipv4.conf.all.rp_filter" = 1;
  #   # Do not accept IP source route packets (we're not a router)
  #   "net.ipv4.conf.all.accept_source_route" = 0;
  #   "net.ipv6.conf.all.accept_source_route" = 0;
  #   # Don't send ICMP redirects (again, we're on a router)
  #   "net.ipv4.conf.all.send_redirects" = 0;
  #   "net.ipv4.conf.default.send_redirects" = 0;
  #   # Refuse ICMP redirects (MITM mitigations)
  #   "net.ipv4.conf.all.accept_redirects" = 0;
  #   "net.ipv4.conf.default.accept_redirects" = 0;
  #   "net.ipv4.conf.all.secure_redirects" = 0;
  #   "net.ipv4.conf.default.secure_redirects" = 0;
  #   "net.ipv6.conf.all.accept_redirects" = 0;
  #   "net.ipv6.conf.default.accept_redirects" = 0;
  #   # Protects against SYN flood attacks
  #   "net.ipv4.tcp_syncookies" = 1;
  #   # Incomplete protection again TIME-WAIT assassination
  #   "net.ipv4.tcp_rfc1337" = 1;

  #   ## TCP optimization
  #   # TCP Fast Open is a TCP extension that reduces network latency by packing
  #   # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
  #   # both incoming and outgoing connections:
  #   "net.ipv4.tcp_fastopen" = 3;
  #   # Bufferbloat mitigations + slight improvement in throughput & latency
  #   "net.ipv4.tcp_congestion_control" = "bbr";
  #   "net.core.default_qdisc" = "cake";
  # };
  # boot.plymouth.enable = true;
  # boot.consoleLogLevel = 0;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  fileSystems =
    let
      zfs_device = d: { device = "${zfs_root}/${d}"; fsType = "zfs"; neededForBoot = true; };
    in
    {
      "/boot".device = "/dev/disk/by-label/boot";
      "/" = zfs_device "yeet";
      "/u" = zfs_device "keep";
      "/nix" = zfs_device "nix";
    };
  swapDevices = [ ];
  # powerManagement.cpuFreqGovernor = "performance";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    # extraPackages =
    #   with pkgs;
    #   let intel_vaapi_driver =
    #     if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
    #       vaapiIntel
    #     else
    #       intel-vaapi-driver;
    #   in [
    #     intel_vaapi_driver
    #     libvdpau-va-gl
    #     intel-media-driver
    #     vulkan-loader
    #     vulkan-validation-layers
    #     vulkan-extension-layer
    #     vulkan-tools
    #   ];
  };
  # automatic screen orientation
  # sensor.iio.enable = true; 
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  hardware.pulseaudio.enable = true; # TODO: conflicts with pipewire, bluetooth@wiki says enable this??

  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [ sane-airscan ];
  };

  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
    # sensitivity = 255;
  };
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.hostId = "4e98920d";
  networking.useDHCP = lib.mkDefault true;
  networking.firewall.enable = false;
  networking.firewall.trustedInterfaces = [ "docker0" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.settings.substituters = [
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  # # This will add each flake input as a registry
  # # To make nix3 commands consistent with your flake
  # nix.registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
  # # This will additionally add your inputs to the system's legacy channels
  # # Making legacy nix commands consistent as well, awesome!
  # nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    # inputs.fenix.overlays.default
    (_: super:
      let
        fenix = inputs.fenix;
        pkgs = fenix.inputs.nixpkgs.legacyPackages.${super.system};
        overlay = fenix.overlays.default;
      in
        overlay pkgs pkgs
    )
  ];
  # virtualisation.virtualbox.guest.enable = true;
  programs.nano.enable = false;
  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.adb.enable = true;
  # programs.steam.enable = true;
  # programs.ssh.startAgent = true;
  environment.persistence."/${keep}/.rootfs" = {
    directories =
      let
        homepath = p: "/home/${mainuser}/${p}";
      in
      [
        "/var/log"
        "/var/lib/flatpak"
        "/etc/NetworkManager/system-connections"
        (homepath ".cache")
        (homepath ".config/VSCodium")
        (homepath ".config/nvim")
        (homepath ".gnupg")
        (homepath ".local/share/flatpak")
        (homepath ".local/share/keyrings")
        (homepath ".local/share/nvim")
        (homepath ".local/share/qBittorrent")
        (homepath ".logseq")
        (homepath ".mozilla")
        (homepath ".ssh")
        (homepath ".thunderbird")
        (homepath ".var/app")
        (homepath ".zoom")
        (homepath "Documents")
        (homepath "Downloads")
        (homepath "Music")
        (homepath "Pictures")
        (homepath "Videos")
        (homepath "VirtualBox VMs")
      ];
    files = [ ];
  };
  time.timeZone = "UTC";
  users.defaultUserShell = pkgs.zsh;
  users.mutableUsers = false;
  users.users.root.initialPassword = mainuser_password;
  users.users.${mainuser} = {
    initialPassword = mainuser_password;
    isNormalUser = true;
    extraGroups = [
      "adbusers"
      "audio"
      "docker"
      "libvirtd"
      "lp"
      "networkmanager"
      "scanner"
      "vboxusers"
      "video"
      "wheel"
    ];
  };
  users.extraGroups.vboxusers.members = [ mainuser ];
  console = {
    useXkbConfig = true; 
    # font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    # font = "ter-132n";
    # packages = with pkgs; [ terminus_font ];
    earlySetup = true;
  };
  documentation = {
    enable = true;
    dev.enable = true;
    # doc.enable = true; # TODO: deprecated?
    man.enable = true;
    man.generateCaches = true;
    info.enable = true;
    nixos.enable = true;
    nixos.includeAllModules = true;
  };
  security.sudo.wheelNeedsPassword = false;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.${mainuser}.enableGnomeKeyring = true;
  security.rtkit.enable = true;
  security.protectKernelImage = true;
  services.gnome.gnome-keyring.enable = true;
  services.flatpak.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  services.fstrim.enable = true;
  services.getty.autologinUser = mainuser;
  services.saned.enable = true;
  services.printing.enable = true;
  services.printing.browsing = true;
  services.printing.stateless = true;
  services.printing.defaultShared = true;
  services.printing.drivers = with pkgs; [
    cnijfilter2
    cups-bjnp
    gutenprint
    splix
  ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.publish = {
    enable = true;
    addresses = true;
    workstation = true;
    userServices = true;
  };
  services.avahi.openFirewall = true;
  # services.unclutter.enable = true;
  # services.unclutter.timeout = 1;
  # services.unclutter.threshold = 1;
  # services.unclutter.extraOptions = [
  #   "jitter 1"
  #   "ignore-scrolling"
  #   "hide-on-touch"
  #   "start-hidden"
  # ];

  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   wireplumber.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   # jack.enable = true;
  # };
  # sound.enable = true;
  services.openssh.enable = false;
  # services.blueman.enable = true;
  services.fprintd.enable = true;
  # services.mullvad-vpn.enable = true;
  # services.logind = {
  #   killUserProcesses = true;
  #   lidSwitch = "suspend";
  #   lidSwitchDocked = "ignore";
  #   lidSwitchExternalPower = "ignore";
  #   extraConfig = "IdleAction=lock";
  # };
  # services.kmscon = {
  #   enable = true;
  #   hwRender = true;
  #   # extraConfig = ''
  #   #   font-name=MesloLGS NF
  #   #   font-size=14
  #   # '';
  # };
  # services.getty = {
  #   greetingLine = "";
  #   autologinUser = "u";
  # };
  services.ipp-usb.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = mainuser;
  services.xserver.libinput.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl";
  services.xserver.xkbOptions = "caps:escape";
  services.xserver.wacom.enable = lib.mkDefault config.services.xserver.enable;
  services.udev.packages = with pkgs; [ android-udev-rules gnome.gnome-settings-daemon ];
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  systemd.services.configure-flathub-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  system.stateVersion = "23.11";
  virtualisation.virtualbox = {
    host.enable = true;
    # host.enableExtensionPack = true;
    # guest.enable = true;
    # guest.x11 = true;
  };
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    autoPrune.enable = true;
  };
  # programs.hyprland.enable = true;
  environment.homeBinInPath = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_USE_XINPUT2 = "1";
  };
  environment.variables = rec {
    EDITOR = "nvim";
    VISUAL = EDITOR;
    LOCAL_TMP = "/${mainuser}/tmp";

    MANPAGER = "nvim -c 'Man!'";
    MANWIDTH = "69";
    PAGER = "nvim -c 'Man!'";
    # VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };
  environment.shells = with pkgs; [ zsh ];
  environment.etc."inputrc".text = inputrc;
  environment.systemPackages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
      "rust-analyzer"
    ])
    (python311.withPackages (ps: with ps; [
      attrs
      grip
      more-itertools
      numpy
      # numpy.linalg
      # numpy.matlib
      # numpy.random
      pynvim
      requests
      typing-extensions
    ]))
    firefox
    zathura
    git
    neovim
    tmux
    alacritty
    tree
    killall
    zsh
    ranger
    gnome.adwaita-icon-theme
    vscodium
    clang
    gcc13
    gh
    bitwarden
    bitwarden-cli
    tesseract
    cachix
    eza
    fd
    ffmpeg-full
    file
    findutils
    appimage-run
    fzf
    ghc
    gimp
    htop-vim
    man
    man-pages
    man-pages-posix
    microcodeIntel
    moreutils
    nix-zsh-completions
    ncdu
    okular
    onlyoffice-bin
    # # materia-theme # TODO: build error
    # # picom # TODO: this one causes rendering artefacts on kde plasma
    # # protonmail-bridge # TODO: does not work
    # swift
    # age
    # androidStudioPackages.dev
    # anki-bin
    # atool
    # audacity
    # blender
    # citra-nightly
    # cloc
    # cryfs
    # czkawka
    # desmume
    # difftastic
    # du-dust
    # duf
    # easyeffects
    # electrum
    # exfat
    # exfatprogs
    # firefox
    # flashfocus
    # flatpak
    # font-manager
    # fuse3
    # git
    # gitAndTools.gitFull
    # gnome.ghex
    # gnome.gnome-disk-utility
    # gnome.gnome-keyring
    # gnome.gnome-software
    # gnome.pomodoro
    # gnome.seahorse
    # gnome.simple-scan
    gnumake
    # gnupg
    # gnused
    # gocryptfs
    # gparted
    # gptfdisk
    # gtkwave
    # gzip
    # helix
    # hfsprogs
    # imagemagick
    # inetutils
    # inkscape
    # jetbrains.idea-community
    # jq
    # kcalc
    # kdeconnect
    # kdenlive
    # keepassxc
    # kotlin
    # krita
    # kwave
    # lapce
    # lazygit
    # libreoffice-fresh
    # libsecret
    # logseq
    # lutris
    # maim
    # meld
    # mixxx
    # mpv
    # mullvad
    # mullvad-browser
    # mullvad-vpn
    # musescore
    # nodePackages.pnpm
    # nodejs
    # nsxiv
    # ntfs3g
    # obs-studio
    # openshot-qt
    # openssh
    # p7zip
    # pamixer
    # pass
    # passExtensions.pass-otp
    # pavucontrol
    # pcmanfm
    # pdfarranger
    # peek
    # perl
    # podman
    # poppler
    # procs
    # pulsemixer
    # qbittorrent
    # qemu
    # qrencode
    # ranger
    # readline
    # redshift
    # ripdrag
    # ripgrep
    # ripgrep-all
    # rmlint
    # sane-airscan
    # sane-backends
    # sd
    # shotcut
    # signal-desktop-beta
    # snapshot
    # sshfs
    # steam
    sxiv
    # syncthing
    # syncthingtray
    tectonic
    thunderbird
    # tldr
    # tor-browser-bundle-bin
    trash-cli
    # tree
    # udiskie
    # udisks
    # unclutter
    # ungoogled-chromium
    # unzip
    # usbutils
    # virt-manager
    # vscodium
    # watchman
    # wget
    # which
    # wireplumber
    # xclip
    # xorg.xhost
    # xorg.xkill
    # xournalpp
    # xsv
    # yt-dlp
    # zathura
    # zip
    # zsh
    # zsh-completions
    # zsh-fzf-tab
    # zsh-syntax-highlighting
  ];
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
      cm_unicode
      fira
      fira-code
      fira-code-symbols
      fira-code-nerdfont
      gyre-fonts
      hubot-sans
      ibm-plex
      inter
      iosevka
      lato
      liberation-sans-narrow
      lmodern
      meslo-lgs-nf
      mona-sans
      monaspace
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      open-sans
      public-sans
      roboto
      source-sans
      work-sans
    ];

    fontconfig = {
      defaultFonts = let default = "Inter"; in {
        serif = [ default  ];
        sansSerif = [ default ];
        monospace = [ "Iosevka" ];
      };
    };
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # extraSpecialArgs = { inherit inputs outputs; };
    extraSpecialArgs = { inherit inputs; };
    users.${mainuser} = hm_inputs @ { pkgs, builtins, config, ... }: {
      home = {
        stateVersion = "23.11";
        username = mainuser;
        homeDirectory = "/home/${mainuser}";
        file = 
          let
            file = p: ./home-manager/file/${p};
          in
          {
            "bin".source = file "bin";
            ".local/bin".source = file "bin";
            ".local/include".source = file ".local/include";
            # ".local/share/nvim".source = file ".local/share/nvim";
            # ".config/nvim".source = file ".config/nvim";

            # TODO: make the ranger confdir writable without pain
            ".config/ranger/colorschemes".source = file ".config/ranger/colorschemes";
            ".config/ranger/plugins".source = file ".config/ranger/plugins";
            ".config/ranger/commands.py".source = file ".config/ranger/commands.py";
            ".config/ranger/rc.conf".source = file ".config/ranger/rc.conf";
            ".config/ranger/rifle.conf".source = file ".config/ranger/rifle.conf";
            ".config/ranger/scope.sh".source = file ".config/ranger/scope.sh";

            ".config/htop/htoprc".source = file ".config/htop/htoprc";
            ".config/inputrc".text = inputrc;
          };
      };
      systemd.user.startServices = "sd-switch";
      programs = import ./home-manager/programs hm_inputs;
      dconf.settings = {
        "org/gnome/desktop/peripherals/touchpad" = {
          speed = 0.33;
          disable-while-typing = false;
          # tap-to-click = true;
        };
        "org/gnome/shell" = {
          favorite-apps = [];
        };
      };
    };
  };
  i18n =
    let
      default_locale = "en_US.UTF-8";
      date_locale = "de_DE.UTF-8";
    in
    {
    defaultLocale = default_locale;
    extraLocaleSettings = {
      LC_ADDRESS = date_locale;
      LC_IDENTIFICATION = date_locale;
      LC_MEASUREMENT = date_locale;
      LC_MONETARY = date_locale;
      LC_NAME = date_locale;
      LC_NUMERIC = date_locale;
      LC_PAPER = date_locale;
      LC_TELEPHONE = date_locale;
      LC_TIME = date_locale;
    };
  };
  location.provider = "geoclue2";
}

# TODO: declaratively manage flatpaks and their permissions
# flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak update
# flatpak install flathub \
#   ch.protonmail.protonmail-bridge \
#   com.bitwig.BitwigStudio \
#   com.discordapp.Discord \
#   com.github.tchx84.Flatseal \
#   com.slack.Slack \
#   flathub com.spotify.Client \
#   io.github.Figma_Linux.figma_linux \
#   md.obsidian.Obsidian \
#   us.zoom.Zoom \
