# Notebook packages
{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Development
    perf
    phoronix-test-suite
    geekbench
    pfetch
    gh
    trash-cli
    tinycc
    zig
    nil
    nixd
    opencode
    gping
    cbonsai

    # Browsers
    firefox
    brave

    # Password manager
    _1password-gui
    _1password-cli

    # Gaming
    steam
    steam-devices-udev-rules
    protonup-qt
    mangohud
    superTuxKart
    prismlauncher

    # GPU tools
    mesa-demos
    nvtopPackages.nvidia
    nvidia-vaapi-driver
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    kooha

    # Media
    feh
    upscayl
    easyeffects
    pavucontrol
    pamixer
    rnnoise-plugin
    playerctl
    cava
    kew

    # Fonts
    fira-code
    hack-font
    jetbrains-mono
    montserrat
    nerd-fonts.droid-sans-mono
    nerd-fonts.iosevka
    nerd-fonts.monaspace
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
    monaspace
    inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
    ipafont
    kochi-substitute

    # Desktop utilities
    polkit_gnome
    bibata-cursors
    flameshot
    waypaper
    swaybg
    swayosd
    wl-clipboard
    libnotify

    # Applications
    equibop
    syncthing
    obsidian
    telegram-desktop
    localsend
    minikube

    # Theming
    papirus-icon-theme
    papirus-folders
    nwg-look
    adw-gtk3

    # Database
    postgresql_18

    # Hyprland plugins
    hyprlandPlugins.hyprspace

    vesktop
    bitwarden-cli
    bitwarden-desktop
    jetbrains.datagrip
    gnumake
    inetutils
    dig
    quickshell
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qt5compat
    qt6.qtmultimedia
    qt6.qtshadertools
    qt6.qtsvg
    qt6.qtquicktimeline
    man-pages 
    man-pages-posix
  ];
}
