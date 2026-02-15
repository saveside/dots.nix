# Base home configuration - applied to ALL hosts (including servers)
# Contains: shell, CLI tools, base packages
{ pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./kubernetes.nix
  ];

  #############################################################################
  # Base Packages (all hosts)
  #############################################################################

  home.packages = with pkgs; [
    # System utilities
    fastfetch
    inxi
    pciutils
    lm_sensors
    tree
    fd
    fzf
    killall
    jq
    file

    # Development
    git
    vim
    gcc
    go
    clang-tools
    sops
    age

    # Network tools
    aria2
    traceroute
    grc

    # Misc CLI
    gum
    ffmpeg
    remmina
    python3
  ];
}
