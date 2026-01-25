{ config, pkgs, lib, spicePkgs, unstable, ... }:

let
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
        firefox
    	nerd-fonts.fira-code
    	nerd-fonts.droid-sans-mono
    	rubik
    	colloid-icon-theme
    	marble-shell-theme
        cava
        hyprland
    	
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
      # Set shell theme
      "org/gnome/shell/extensions/user-theme" = {
        name = "Marble-blue-light";
      };
      # Set interface themes (icon theme, GTK theme, cursor theme)
      "org/gnome/desktop/interface" = {
        gtk-theme = "Marble-blue-light";
        icon-theme = "Colloid";
        color-scheme = "prefer-dark";
      };
       # Set legacy app theme
      "org/gnome/desktop/wm/preferences" = {
        theme = "Adw-gtk-3-dark";
      };
    };
  };

  xdg.configFile = {
    "fastfetch/nix.jsonc".source = mkLink "${dotfiles}/fastfetch/nix.jsonc";
    "hypr/hyprland.conf".source        = mkLink "${dotfiles}/hypr/hyprland.conf";
    "Ambxst/wallpapers.json".source    = mkLink "${dotfiles}/Ambxst/wallpapers.json";
    "nvim/init.lua".source             = mkLink "${dotfiles}/nvim/init.lua";
    "nvim/lua/plugins/catppuccin.lua".source = mkLink "${dotfiles}/nvim/lua/plugins/catppuccin.lua";
    "nvim/lua/plugins/lualine.lua".source = mkLink "${dotfiles}/nvim/lua/plugins/lualine.lua";
    "nvim/lua/plugins/nvim-tree.lua".source = mkLink "${dotfiles}/nvim/lua/plugins/nvim-tree.lua";
    "nvim/lua/plugins/telescope.lua".source = mkLink "${dotfiles}/nvim/lua/plugins/telescope.lua";
    "nvim/lua/plugins/alpha.lua".source = mkLink "${dotfiles}/nvim/lua/plugins/alpha.lua";
    "nvim/lua/plugins/lsp_and_cmp.lua".source = mkLink "${dotfiles}/nvim/lua/plugins/lsp_and_cmp.lua";
    "qtile/config.py".source           = mkLink "${dotfiles}/qtile/config.py";
    "niri/config.toml".source          = mkLink "${dotfiles}/niri/config.toml";
    "spicetify/config.ini".source      = mkLink "${dotfiles}/spicetify/config.ini";
  };
  programs.ghostty = {
  enable = true;
  enableZshIntegration = true;
  settings = {
   theme = "Black Metal";
   background-opacity = "0.70";
   background-blur = true;
   window-theme = "ghostty";
  };
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
  home.file.".config/fastfetch/image/cirno2.png".source = mkLink "${dotfiles}/fastfetch/image/cirno2.png";

  # Configure Spicetify using the spicePkgs package set computed in flake.nix
  programs.spicetify = {
    enable = true;
    # use the spicePkgs (legacyPackages from the spicetify flake)
    theme = spicePkgs.themes.lucid;
    enabledExtensions = with spicePkgs.extensions; [
      coverAmbience
      history
      betterGenres
      simpleBeautifulLyrics 
      hidePodcasts
      shuffle
    ];
  };
}

