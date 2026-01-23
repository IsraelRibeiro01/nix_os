{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # using the ambxst package from flake input
    inputs.ambxst.packages.${pkgs.system}.default
  ];

  # if Ambxst needs service-like files or to be started automatically,
  # you can add a systemd user service or a wrapper here. Usually Ambxst
  # is run from the compositor (hyprland) with exec-once.
}

