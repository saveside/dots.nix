# Notebook home configuration
{ inputs, pkgs, ... }:

{
  imports = [
    ../base.nix
    ../modules/desktop/hyprland
    ../modules/editors.nix
    ../modules/opencode.nix
    ../modules/media.nix
    ../modules/desktop/sway
    ../modules/browsers.nix
    ../modules/tools
    ../modules/desktop/sway/waybar.nix
    ../modules/apps/alacritty.nix
    ../modules/desktop/sway/swaync.nix
    ../modules/apps/vicinae.nix
    ../modules/apps/zathura.nix
    ../modules/apps/librewolf.nix
  ];

  programs.home-manager.enable = true;

  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    NIXOS_OZONE_WL = "1";
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  home.packages = with pkgs; [
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    unzip
    nodejs
    onefetch
    rustup
    kdePackages.qt6ct
    kdePackages.qtstyleplugin-kvantum
    kdePackages.ark
    blueman
    bcc
    bpftrace
    llvm
    libbpf
    tcpdump
    termshark
    ethtool
    neovim
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
    pcmanfm-qt
    cmake
    firefox
    brave
    _1password-gui
    _1password-cli
    steam
    steam-devices-udev-rules
    protonup-qt
    mangohud
    superTuxKart
    prismlauncher
    mesa-demos
    nvtopPackages.nvidia
    nvidia-vaapi-driver
    kooha
    feh
    upscayl
    easyeffects
    pavucontrol
    pamixer
    rnnoise-plugin
    playerctl
    cava
    kew
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
    polkit_gnome
    bibata-cursors
    flameshot
    waypaper
    swaybg
    swayosd
    wl-clipboard
    libnotify
    equibop
    syncthing
    obsidian
    telegram-desktop
    localsend
    minikube
    papirus-icon-theme
    papirus-folders
    nwg-look
    adw-gtk3
    postgresql_18
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
    uzdoom
  ];
}
