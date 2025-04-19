{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  ########################################
  #
  ## Home Manager Required Variables
  #
  ########################################
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  ########################################
  #
  ## Packages
  #
  ########################################
  home.packages = with pkgs; [
    #~ custom ~#
    inputs.self.packages."${pkgs.system}".zmem

    #~ fonts ~#
    fira-code
    font-awesome_5
    hack-font
    jetbrains-mono
    montserrat
    nerd-fonts.droid-sans-mono
    nerd-fonts.iosevka
    nerd-fonts.monaspace
    noto-fonts-color-emoji
    ubuntu_font_family

    #~ standard packages ~#
    adw-gtk3
    alacritty-theme
    ansible
    aria2
    bc
    binwalk
    btop
    bun
    fastfetch
    gdb
    gnome-icon-theme
    gnome-tweaks
    grc
    grim
    hyperfine
    iftop
    imagemagick
    iperf
    jq
    k0sctl
    k9s
    kdePackages.qtstyleplugin-kvantum
    kdePackages.qtwayland
    kubectl
    kubernetes-helm
    kubetail
    libsForQt5.qtstyleplugin-kvantum
    lsd
    minikube
    netcat
    nixd
    nixfmt-rfc-style
    nmap
    nvtopPackages.full
    nwg-look
    ocs-url
    pavucontrol
    playerctl
    postgresql_17
    r2modman
    rnnoise-plugin
    rsync
    scrcpy
    shellcheck
    slurp
    swappy
    swaybg
    swayidle
    tmux
    traceroute
    translate-shell
    tree
    unrar
    unzip
    wl-clipboard
    wlr-randr
    wlsunset
    wtype
    ydotool
    yq
    yt-dlp
  ];

  ########################################
  #
  ## Module Configurations
  #
  ########################################
  #~ custom modules ~#
  moduleopts = {
    alacritty.theme = "rose_pine";
    sway.enable = false;
    waybar.weather_location = "Istanbul";
  };

  #~ xdg ~#
  xdg.mime.enable = true;

  ########################################
  #
  ## Variables
  #
  ########################################
  home.sessionVariables = {
    ##############################
    ## APPS
    ##############################
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";

    ##############################
    ## SYSTEM
    ##############################
    LD_LIBRARY_PATH = "$HOME/.local/lib64:$HOME/.local/lib:$HOME/.nix-profile/lib64:$HOME/.nix-profile/lib:/usr/local/lib64:/usr/local/lib";
    XDG_DATA_DIRS = "$HOME/.local/share:$HOME/.nix-profile/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS";
    EDITOR = "vim";
    SYSTEMD_EDITOR = "vim";
  };

  ########################################
  #
  ## Other Configurations
  #
  ########################################
  home.activation = { };
  imports =
    lib.map (p: ./. + "/${p}") (lib.remove "default.nix" (lib.attrNames (builtins.readDir ./.)))
    ++ [ inputs.self.homeManagerModules.saveside ];
}
