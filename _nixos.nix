{ inputs, outputs, home-manager, config, lib, pkgs, builtins, ... }: {
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "ata_piix"
        "ehci_pci"
        "nvme"
        "ohci_pci"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];

      kernelModules = [
        "i915"
        "kvm-intel"
      ];

      luks.devices."luks".device = "/dev/disk/by-label/luks";
      verbose = false;
    };

    plymouth.enable = true;
    consoleLogLevel = 0;

    kernel.sysctl = {
      # The Magic SysRq key is a key combo that allows users connected to the
      # system console of a Linux kernel to perform some low-level commands.
      # Disable it, since we don't need it, and is a potential security concern.
      "kernel.sysrq" = 0;

      ## TCP hardening
      # Prevent bogus ICMP errors from filling up logs.
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      # Reverse path filtering causes the kernel to do source validation of
      # packets received from all interfaces. This can mitigate IP spoofing.
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      # Do not accept IP source route packets (we're not a router)
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      # Don't send ICMP redirects (again, we're on a router)
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      # Refuse ICMP redirects (MITM mitigations)
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      # Protects against SYN flood attacks
      "net.ipv4.tcp_syncookies" = 1;
      # Incomplete protection again TIME-WAIT assassination
      "net.ipv4.tcp_rfc1337" = 1;

      ## TCP optimization
      # TCP Fast Open is a TCP extension that reduces network latency by packing
      # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
      # both incoming and outgoing connections:
      "net.ipv4.tcp_fastopen" = 3;
      # Bufferbloat mitigations + slight improvement in throughput & latency
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };

    kernelModules = [
      "kvm-intel"
      "i915"
      "tcp_bbr"
    ];

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "i915.enable_fbc=1"
      "i915.enable_psr=2"
      "log_level=0"
      "quiet"
      "rd.systemd.show_status=false"
      "splash"
      "udev.log_level=3"
    ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    
    tmp.cleanOnBoot = true;
  };


  console = {
    useXkbConfig = true; 
    # font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    # font = "ter-132n";
    # packages = with pkgs; [ terminus_font ];
    earlySetup = true;
  };

  containers = {
    zoom =
      let
        app_name = "zoom";
      in {
        autoStart = false;

        ephemeral = true;

        bindMounts = {
          tmp_xserver =
            let
              p = "/tmp/.X11-unix";
            in {
              mountPoint = p;
              hostPath = p;
              isReadOnly = true;
            };
        };

        allowedDevices = [

        ];

        config = { config, pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;

          environment.variables.DISPLAY = ":0";

          environment.systemPackages = with pkgs; [
            zoom-us
            firefox
          ];

          system.stateVersion = "23.11";

          services.xserver.enable = true;

          users.users = {
            root.initialPassword = app_name;

            ${app_name} = {
              isNormalUser = true;

              initialPassword = app_name;

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
          };
        };
      };
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

  environment =
    let
      EDITOR = "nvim";
      VISUAL = EDITOR;
    in {
      homeBinInPath = true;

      systemPackages = with pkgs; [
        # (fenix.complete.withComponents [
        #   "cargo"
        #   "clippy"
        #   "rust-src"
        #   "rustc"
        #   "rustfmt"
        #   "rust-analyzer"
        # ])

        # (python311.withPackages (ps: with ps; [
        #   attrs
        #   grip
        #   more-itertools
        #   numpy
        #   # numpy.linalg
        #   # numpy.matlib
        #   # numpy.random
        #   pynvim
        #   requests
        #   typing-extensions
        # ]))

        # materia-theme # TODO: build error
        # picom # TODO: this one causes rendering artefacts on kde plasma
        # protonmail-bridge # TODO: does not work
        # swift
        # age
        alacritty
        # androidStudioPackages.dev
        # anki-bin
        # appimage-run
        # atool
        # audacity
        # bitwarden
        # bitwarden-cli
        # blender
        cachix
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
        # eza
        # fd
        # ffmpeg-full
        # file
        # findutils
        firefox
        # flashfocus
        # flatpak
        # font-manager
        # fuse3
        fzf
        # gcc13
        # gh
        # ghc
        # gimp
        git
        # gitAndTools.gitFull
        # gnome.ghex
        # gnome.gnome-disk-utility
        # gnome.gnome-keyring
        # gnome.gnome-software
        # gnome.pomodoro
        # gnome.seahorse
        # gnome.simple-scan
        gnugrep
        gnumake
        # gnupg
        gnused
        # gocryptfs
        # gparted
        # gptfdisk
        # gtkwave
        # gzip
        # helix
        # hfsprogs
        # htop-vim
        # imagemagick
        # inetutils
        # inkscape
        # jetbrains.idea-community
        # jq
        # kcalc
        # kdeconnect
        # kdenlive
        # keepassxc
        killall
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
        # man
        # man-pages
        # man-pages-posix
        # meld
        # microcodeIntel
        # mixxx
        # moreutils
        # mpv
        # mullvad
        # mullvad-browser
        # mullvad-vpn
        # musescore
        # ncdu
        neovim
        nix-zsh-completions
        # nodePackages.pnpm
        # nodejs
        # nsxiv
        # ntfs3g
        # obs-studio
        # okular
        # onlyoffice-bin
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
        perl
        # podman
        # poppler
        # procs
        # pulsemixer
        # qbittorrent
        # qemu
        # qrencode
        ranger
        readline
        # redshift
        # ripdrag
        ripgrep
        ripgrep-all
        # rmlint
        # sane-airscan
        # sane-backends
        # sd
        # shotcut
        # signal-desktop-beta
        # snapshot
        # sshfs
        # steam
        # sxiv
        # syncthing
        # syncthingtray
        # tectonic
        # thunderbird
        # tldr
        tmux
        # tor-browser-bundle-bin
        # trash-cli
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
        zsh
        zsh-completions
        zsh-fzf-tab
        zsh-syntax-highlighting
      ];
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

      sessionVariables = {
        MOZ_USE_XINPUT2 = "1";
      };

      variables = {
        EDITOR = EDITOR;
        VISUAL = VISUAL;
        LOCAL_TMP = "/\${USER}/tmp";

        MANPAGER = "nvim -c 'Man!'";
        MANWIDTH = "69";
        PAGER = "nvim -c 'Man!'";

        VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
      };

      plasma5.excludePackages = with pkgs.libsForQt5; [
        elisa
        ksshaskpass
        # gwenview
        # nano # TODO: removing nano does not work like this
        # okular
        oxygen
        khelpcenter
        # konsole
        # plasma-browser-integration
        # print-manager
      ];

      shells = with pkgs; [ zsh ];

      etc = {
        # "inputrc".source = ./inputrc;
      };
    };


  fileSystems = {
    "/boot".device = "/dev/disk/by-label/boot";
    "/".device = "/dev/disk/by-label/root";
  };


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


  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages =
        with pkgs;
        let intel_vaapi_driver =
          if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
            vaapiIntel
          else
            intel-vaapi-driver;
        in [
          intel_vaapi_driver
          libvdpau-va-gl
          intel-media-driver
          vulkan-loader
          vulkan-validation-layers
          vulkan-extension-layer
          vulkan-tools
        ];
    };

    # automatic screen orientation
    sensor.iio.enable = true; 

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    # pulseaudio.enable = true; # TODO: conflicts with pipewire, bluetooth@wiki says enable this??

    sane = {
      enable = true;
      extraBackends = with pkgs; [ sane-airscan ];
    };

    trackpoint = {
      enable = true;
      emulateWheel = true;
      # sensitivity = 255;
    };
  };


  # home-manager = {
    # "bin".source = ./bin;
    # ".local/bin".source = ./bin;
    # ".local/include".source = ./.local/include;
    # # ".local/share/nvim".source = ./.local/share/nvim;
    # # ".config/nvim".source = ./.config/nvim;

    # # TODO: make the ranger confdir writable without pain
    # ".config/ranger/colorschemes".source = ./.config/ranger/colorschemes;
    # ".config/ranger/plugins".source = ./.config/ranger/plugins;
    # ".config/ranger/commands.py".source = ./.config/ranger/commands.py;
    # ".config/ranger/rc.conf".source = ./.config/ranger/rc.conf;
    # ".config/ranger/rifle.conf".source = ./.config/ranger/rifle.conf;
    # ".config/ranger/scope.sh".source = ./.config/ranger/scope.sh;

    # ".config/htop/htoprc".source = ./.config/htop/htoprc;
    # ".config/inputrc".source = ../../environment/etc/inputrc;
  # };

  i18n =
    let
      default_locale = "en_US.UTF-8";
      date_locale = "de_DE.UTF-8";
    in {
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


  location = {
    provider = "geoclue2";
  };


  networking = {
    hostName = "u";

    useDHCP = lib.mkDefault true;

    networkmanager.enable = true;

    firewall = {
      enable = false;
      trustedInterfaces = [ "docker0" ];
    };
  };


  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      
      auto-optimise-store = true;

      substituters = [
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };


  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";

    overlays = [
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
    
    config = {
      allowUnfree = true;
    };
  };


  powerManagement.cpuFreqGovernor = "performance";


  programs = {
    zsh = {
      enable = true;
    };

    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # switched to home-manager managing tmux
    # tmux = {
    #   enable = true;
    #   newSession = true;
    #   keyMode = "vi";
    #   escapeTime = 0;
    #   historyLimit = 1000000;
    # };

    adb.enable = true;

    dconf.enable = true;

    kdeconnect = {
      enable = true;
    };
  
    steam = {
      enable = true;
    };

    ssh = {
      startAgent = true;
    };
  };


  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
    protectKernelImage = true;
    pam.services."u" = {
      enableGnomeKeyring = true;
    };
  };


  services = {
    printing = {
      enable = true;

      browsing = true;

      stateless = true;

      defaultShared = true;

      drivers = with pkgs; [
        cnijfilter2
        cups-bjnp
        gutenprint
        splix
      ];
    };

    xserver = {
      enable = true;
      libinput.enable = true;

      # windowManager.dwm = { enable = false; };

      desktopManager.plasma5 = {
        enable = true;
        useQtScaling = true;
      };

      displayManager = {
        autoLogin = {
          enable = true;
          user = "u";
        };

        sddm = {
          enable = true;
          # timeout = 0;
        };
      };

      videoDrivers = [ "modesetting" ];
      # videoDrivers = [ "intel" ];

      deviceSection = ''
        Option "DRI" "2"
        Option "TearFree" "true"
      '';

      # dpi = 150;

      # autorun = true;
      # autoRepeatDelay = TODO;
      # autoRepeatInterval = TODO;

      layout = "us";
      xkbVariant = "altgr-intl";
      xkbOptions = "caps:escape";

      wacom.enable = lib.mkDefault config.services.xserver.enable;
    };

    saned.enable = true; 

    flatpak.enable = true;

    avahi = {
      enable = true;

      nssmdns = true;

      publish = {
        enable = true;
        addresses = true;
        workstation = true;
        userServices = true;
      };

      openFirewall = true;
    };
  
    gnome.gnome-keyring.enable = true;
  
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;
    };
  
    openssh.enable = false;
    
    blueman.enable = true;

    udev = {
      packages = with pkgs; [
        android-udev-rules
      ];
    };

    fstrim.enable = true;

    # login and unlock with fingerprint (if you add one with `fprintd-enroll`)
    fprintd.enable = true;

    mullvad-vpn.enable = true;

    logind = {
      killUserProcesses = true;
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      extraConfig = ''
        IdleAction=lock
      '';
    };

    kmscon = {
      enable = true;
      hwRender = true;
      # extraConfig = ''
      #   font-name=MesloLGS NF
      #   font-size=14
      # '';
    };

    # TODO: picom with KDE Plasma leads to rendering artefacts
    # picom = {
    #   enable = true;
    #   vSync = true;
    # };

    # getty = {
    #   greetingLine = "";
    #   autologinUser = "u";
    # };

    ipp-usb.enable = true;

    unclutter =  {
      enable = true;
      timeout = 1;
      threshold = 1;

      extraOptions = [
        "jitter 1"
        "ignore-scrolling"
        "hide-on-touch"
        "start-hidden"
      ];
    };
  };


  sound = {
    enable = false;
  };


  swapDevices = [ ];


  system = {
    stateVersion = "23.11";
  };


  time = {
    timeZone = "Europe/Berlin";
  };


  users = {
    defaultUserShell = pkgs.zsh;

    users = {
      "root".initialPassword = "correcthorsebatterystaple";

      "u" = {
        isNormalUser = true;

        initialPassword = "correcthorsebatterystaple";

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
    };

    extraGroups = {
      vboxusers.members = [ "u" ];
    };
  };

  virtualisation = {
    virtualbox = {
      host.enable = true;
      # host.enableExtensionPack = true;
      # guest.enable = true;
      # guest.x11 = true;
    };
  
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };

    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      autoPrune.enable = true;
    };
  };
}
