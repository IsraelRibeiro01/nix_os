{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    tree
    gh
  ];

  # --- Fonts ---
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    cascadia-code
    monaspace
    hack-font
    fantasque-sans-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.comic-shanns-mono
    nerd-fonts.victor-mono
    nerd-fonts.iosevka
    nerd-fonts.recursive-mono
    nerd-fonts.geist-mono
    rubik
    nerd-fonts.ubuntu
  ];
}
