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
    inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd

    #~ fonts ~#
    fira-code
    hack-font
    jetbrains-mono
    montserrat
    nerd-fonts.droid-sans-mono
    nerd-fonts.iosevka
    nerd-fonts.monaspace
    noto-fonts-color-emoji
    ubuntu_font_family

    #~ standard packages ~#
    _1password-cli
    adw-gtk3
    alacritty-theme
    ansible
    aria2
    bat
    bat-extras.batman
    bc
    binwalk
    btop
    cliphist
    delta
    direnv
    fastfetch
    gdb
    gef
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
    minio-client
    netcat
    nixd
    nixfmt-rfc-style
    nmap
    nvtopPackages.full
    nwg-look
    ocs-url
    onefetch
    pavucontrol
    pipes-rs
    playerctl
    postgresql_17
    r2modman
    rnnoise-plugin
    rsync
    scrcpy
    shellcheck
    slurp
    strace
    swappy
    swaybg
    swayidle
    tesseract
    tmux
    traceroute
    translate-shell
    trash-cli
    tree
    universal-android-debloater
    unrar
    unzip
    wl-clipboard
    wlr-randr
    wlroots_0_17
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
    easyeffects.enable = false;
    mako.enable = false;
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
    #LD_LIBRARY_PATH = "$HOME/.local/lib64:$HOME/.local/lib:/usr/local/lib64:/usr/local/lib:/usr/lib64:/usr/lib:$HOME/.nix-profile/lib64:$HOME/.nix-profile/lib:$LD_LIBRARY_PATH";
    #PATH = "$HOME/.local/share/JetBrains/Toolbox/scripts:$HOME/.local/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:$HOME/.nix-profile/sbin:$HOME/.nix-profile/bin";
    #XDG_DATA_DIRS = "$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$HOME/.local/share:/usr/local/share:/usr/share:$HOME/.nix-profile/share:$XDG_DATA_DIRS";
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
  home.activation = {
    postInstall = ''
      $SHELL -c "fisher install ilancosman/tide" &>/dev/null
      $SHELL -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Dotted --prompt_connection_andor_frame_color=Lightest --prompt_spacing=Sparse --icons='Many icons' --transient=Yes" &>/dev/null
    '';
  };
  imports =
    lib.map (p: ./. + "/${p}") (lib.remove "default.nix" (lib.attrNames (builtins.readDir ./.)))
    ++ [ inputs.self.homeManagerModules.saveside ];
}
