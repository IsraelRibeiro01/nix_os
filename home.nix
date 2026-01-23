{ config, pkgs, lib, spicePkgs, ... }:

let
  gext = pkgs.gnomeExtensions;
  dotfiles = "/etc/nixos/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  home.username = "luwiblu";
  home.homeDirectory = "/home/luwiblu";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    initContent = ''
      cat ~/.cache/wal/sequences
      wal -R
      clear
      fastfetch --config nix
    '';
    shellAliases = { 
        ls = "eza -a --icons=always";
        update = "sudo nixos-rebuild switch --flake .#KyujinNixOS";
        clean = "sudo nix-collect-garbage  -d";
    };
    oh-my-zsh.enable = true;
    oh-my-zsh.theme = "dstufft";
  };
  
  fonts.fontconfig.enable = true;

     home.packages =
	(with pkgs; [
	bat
    	eza
    	fastfetch
    	neovim
    	nodejs_22
    	hyprland
        firefox
    	nerd-fonts.fira-code
    	nerd-fonts.droid-sans-mono
    	rubik
  ])
  ++
  (with pkgs.gnomeExtensions; [
    blur-my-shell
    dash-to-dock
    media-controls
    phases-of-moon
    steal-my-focus-window
    user-themes
  ]);

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
        "dash2dock-lite@icedman.github.com"
        "blur-my-shell@aunetx"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "phases-of-moon@melomane13"
        "mediacontrols@cliffniff.github.com"
        "steal-my-focus-window@steal-my-focus-window"
        ];
      };
    };
  };

  xdg.configFile = {
    "fastfetch/config.d/nix.jsonc".source = mkLink "${dotfiles}/fastfetch/nix.jsonc";
    "hypr/hyprland.conf".source        = mkLink "${dotfiles}/hypr/hyprland.conf";
    "Ambxst/wallpapers.json".source    = mkLink "${dotfiles}/Ambxst/wallpapers.json";
    "nvim/init.lua".source             = mkLink "${dotfiles}/nvim/init.lua";
    "qtile/config.py".source           = mkLink "${dotfiles}/qtile/config.py";
    "niri/config.toml".source          = mkLink "${dotfiles}/niri/config.toml";
    "spicetify/config.ini".source      = mkLink "${dotfiles}/spicetify/config.ini";
  };
  
  programs.git = {
  enable = true;
  settings.user = {
    name = "luwiblu";
    email = "luwiblu@gmail.com";
  };
    settings = {
    init.defaultBranch = "master";
    safe.directory = "/etc/nixos";
  };
};

  home.file.".config/fastfetch/image/cirno.png".source = mkLink "${dotfiles}/fastfetch/image/cirno.png";
  home.file.".local/share/wallpapers/1299370.jpg".source = mkLink "${dotfiles}/wallpapers/1299370.jpg";

  # Configure Spicetify using the spicePkgs package set computed in flake.nix
  programs.spicetify = {
    enable = true;
    # use the spicePkgs (legacyPackages from the spicetify flake)
    theme = spicePkgs.themes.comfy;
    colorScheme = "Nord";
    enabledExtensions = with spicePkgs.extensions; [
      hidePodcasts
      shuffle
    ];
  };
}

