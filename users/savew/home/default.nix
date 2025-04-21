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
    CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
    MOZ_ENABLE_WAYLAND = "1";
    PAGER = "most";

    ##############################
    ## QT
    ##############################
    QML_IMPORT_PATH = "$HOME/.local/lib64/qml:$HOME/.local/lib/qml:/usr/local/lib64/qml:/usr/local/lib/qml:$QML_IMPORT_PATH";
    QML2_IMPORT_PATH = "$HOME/.local/lib64/qml:$HOME/.local/lib/qml:/usr/local/lib64/qml:/usr/local/lib/qml:$QML2_IMPORT_PATH";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_PLUGIN_PATH = "$HOME/.local/lib64/plugins:$HOME/.local/lib/plugins:/usr/local/lib64/plugins:/usr/local/lib/plugins:$HOME/.local/lib64/qt5/plugins:$HOME/.local/lib/qt5/plugins:/usr/local/lib64/qt5/plugins:/usr/local/lib/qt5/plugins:$QT_PLUGIN_PATH";
    QT_QPA_PLATFORM = "wayland;xcb";
    # QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    ##############################
    ## SYSTEM
    ##############################
    LD_LIBRARY_PATH = "$HOME/.local/lib64:$HOME/.local/lib:$HOME/.nix-profile/lib64:$HOME/.nix-profile/lib:/usr/local/lib64:/usr/local/lib:$LD_LIBRARY_PATH";
    PATH = "$HOME/.local/share/JetBrains/Toolbox/scripts:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.nix-profile/bin:$PATH";
    XDG_DATA_DIRS = "$HOME/.local/share/flatpak/exports/share:$HOME/.local/share:$HOME/.nix-profile/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS";
    EDITOR = "vim";
    GTK_USE_PORTAL = "1";
    SDL_VIDEODRIVER = "wayland";
    SYSTEMD_EDITOR = "vim";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
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
