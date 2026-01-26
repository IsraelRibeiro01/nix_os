{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../hardware-configuration.nix

    # Home Manager as a NixOS module (flake-based)
    inputs.home-manager.nixosModules.home-manager
    ./modules/ambxst.nix
    ./modules/lazyvim.nix
    ./modules/hyprland.nix
    ../fonts.nix
    ../gaming.nix
  ];
  ## -------------------------
  ## Bootloader
  ## -------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  ## -------------------------
  ## Kernal
  ## ------------------------
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  ## -------------------------
  ## Nix settings
  ## -------------------------
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
  };
  system.autoUpgrade = {
   enable = true;
   flake = inputs.self.outPath;
   dates = "daily";
   allowReboot = false;
 };
  nixpkgs.config.allowUnfree = true;
  
  # systemd services for automatic updates with flakes enabled
  systemd.services.nixos-flake-update = {
    description = "Update NixOS flake inputs";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      WorkingDirectory = "/etc/nixos";
      ExecStart = "${pkgs.nixVersions.stable}/bin/nix flake update";
    };
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };
  systemd.timers.nixos-flake-update = {
    description = "Daily NixOS flake update timer";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "daily";
      OnBootSec = "15min";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
  ## -------------------------
  ## Networking
  ## -------------------------
  networking.hostName = "KyujinNixOS";
  networking.networkmanager.enable = true;
  services.geoclue2.enable = true;
  services.openssh.enable = true;
  hardware.bluetooth.enable = true;
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
  
  ## ----------------------
  ## FIREWALL
  ## ---------------------
  networking.firewall = {
    enable =true;
    allowPing = false;
    allowedTCPPorts = [ 22 ];
    trustedInterfaces = [ "lo"];
 };
    
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";
  
  ## -------------------------------------
  ## Display
  ## ------------------------------------
  services.xserver.enable = true;
  
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  ## ---------------------------------------
  ## Other Desktops
  ## ---------------------------------------
  
  programs.hyprland.enable = true;
  
  # create a Wayland session file for GDM
  environment.etc."share/wayland-sessions/hyprland.desktop".text = ''
  [Desktop Entry]
  Name=Hyprland
  Comment=Hyprland Wayland session
  Exec=Hyprland
  Type=Application
  X-GNOME-Autostart-enabled=false
  NoDisplay=false
'';

  # enable niri if available
  programs.niri.enable = true;

  environment.etc."share/wayland-sessions/niri.desktop".text = ''
  [Desktop Entry]
  Name=Niri
  Comment=Niri Wayland session
  Exec=niri
  Type=Application
  X-GNOME-Autostart-enabled=false
  NoDisplay=false
'';
  services.xserver.windowManager.qtile.enable = true;
  # create an X11 session entry so GDM shows Qtile
  environment.etc."share/xsessions/qtile.desktop".text = ''
  [Desktop Entry]
  Name=Qtile
  Comment=Qtile window manager (X11)
  Exec=qtile start
  TryExec=qtile
  Type=Application
  X-GNOME-Autostart-enabled=false
  NoDisplay=false
'';

  ## -------------------------
  ## Audio
  ## -------------------------
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  ## -------------------------
  ##  NVIDIA
  ## -------------------------
  services.xserver.videoDrivers = [ "nvidia"];
  
  hardware.nvidia = {
     modesetting.enable = true;
     powerManagement.enable = false;
     powerManagement.finegrained = false;

     open = false;
     nvidiaSettings = true; 
   };
  environment.sessionVariables =  {
     NIXOS_OZONE_WL = "1";
  };
  ## -------------------------
  ## Shells (for zsh)
  ## -------------------------
  programs.zsh.enable = true;

  ## -------------------------
  ## Users
  ## -------------------------
  users.users.luwiblu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  ## -------------------------
  ## Home Manager
  ## -------------------------
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.luwiblu = import ../home.nix;
  };
  home-manager.backupFileExtension = "backup";

  ## -------------------------
  ## User avatar (GNOME)
  ## -------------------------
  environment.etc."portraits/Portrait.jodiojoestar.png".source =
    ../dotfiles/wallpapers/Portrait.jodiojoestar.png;

  system.activationScripts.setUserAvatar.text = ''
    mkdir -p /var/lib/AccountsService/icons
    cp -f /etc/portraits/Portrait.jodiojoestar.png \
      /var/lib/AccountsService/icons/luwiblu || true
    cp -f /etc/portraits/Portrait.jodiojoestar.png \
      /home/luwiblu/.face || true
    chown root:root /var/lib/AccountsService/icons/luwiblu || true
  '';

  ## -------------------------
  ## System packages
  ## -------------------------
  environment.systemPackages = with pkgs; [
    fastfetch
    hyprland
    nemo
    neovim
    nodejs_22
    python3
    wget
    unzip
    vesktop
    pywal
    pywalfox-native
    obs-studio
    gnome-tweaks
    bibata-cursors
    blueman
    tty-clock
    gtop
    cbonsai
  ];

  ## -------------------------
  ## Performance
  ## -------------------------
  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

  powerManagement.cpuFreqGovernor = "performance";
  
  programs.dconf.enable = true;

  environment.sessionVariables = {
  XCURSOR_THEME = "Bibata-Modern-Classic";
  XCURSOR_SIZE = "16";
  
  };

  ## -------------------------
  ## NixOS release
  ## -------------------------
  system.stateVersion = "25.11";
}

