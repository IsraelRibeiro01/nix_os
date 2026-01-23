{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../hardware-configuration.nix

    # Home Manager as a NixOS module (flake-based)
    inputs.home-manager.nixosModules.home-manager
    ./modules/ambxst.nix
    ./modules/lazyvim.nix
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

  nixpkgs.config.allowUnfree = true;

  ## -------------------------
  ## Networking
  ## -------------------------
  networking.hostName = "KyujinNixOS";
  networking.networkmanager.enable = true;
  services.geoclue2.enable = true;
  services.openssh.enable = true;
  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
  
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
  programs.hyprland.enable = true;
  programs.niri.enable = true;
  services.xserver.windowManager.qtile.enable = true;

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
    ghostty
    vesktop
    pywal
    obs-studio
    gnome-tweaks
    bibata-cursors
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

