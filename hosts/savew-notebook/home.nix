{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  ########################################
  #
  ## Home Manager Required Variables
  #
  ########################################
  home.username = "savew";
  home.homeDirectory = "/home/savew";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  nixGL.packages = inputs.nixgl.packages;

  ########################################
  #
  ## Packages
  #
  ########################################
  home.packages = with pkgs; [
    #~ nixGL wrapped packages ~#
    config.wrappedPkgs.alacritty
    config.wrappedPkgs.imagemagick
    config.wrappedPkgs.nwg-displays
    config.wrappedPkgs.flameshot

    #~ nerdfonts override ~#
    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "JetBrainsMono"
      ];
    })

    #~ nixGL packages ~#
    ags
    alacritty-theme
    ansible
    autotiling-rs
    bat
    bat-extras.batman
    bibata-cursors
    btop
    bun
    evince
    eza
    fd
    feh
    fzf
    go
    grc
    grim
    gtklock
    gtklock-powerbar-module
    htop
    imv
    iosevka
    jetbrains-mono
    jq
    lxsession
    monaspace
    most
    neofetch
    neovide
    neovim
    nixd
    nixfmt-classic
    nmap
    nvtopPackages.amd
    nwg-look
    pavucontrol
    pcmanfm-qt
    rsync
    sass
    scrcpy
    slurp
    swappy
    swaybg
    swayidle
    swaylock
    swaynotificationcenter
    tmux
    vesktop
    vim
    vscode
    wl-clipboard
    wlr-randr
    wlroots_0_17
    wlsunset
    wpgtk
    wtf
    wtype
    ydotool
    yq
    yt-dlp
    zsh
    zsh-autosuggestions
    zsh-f-sy-h
    zsh-fzf-history-search
  ];

  ########################################
  #
  ## Options
  #
  ########################################
  nix.registry = lib.mapAttrs (_: value: { flake = value; }) inputs; # ~ for nix stable channel
  nixpkgs.config = {
    allowUnfree = true;
  }; # ~ for vscode

  #~ services ~#
  services = {
    kdeconnect = {
      enable = true;
      package = config.wrappedPkgs.kdeconnect;
      indicator = true;
    };
  };

  #~ packages ~#
  pkgconfig = {
    alacritty = {
      enable = true;
      theme = "monokai_charcoal";
    };
    gtklock.enable = true;
    mangohud.enable = true;
    mpv.enable = true;
    rofi.enable = true;
    sway.enable = true;
    waybar = {
      enable = true;
      weather_location = "Istanbul";
    };
    wtf.enable = true;
    zathura.enable = true;
    zsh.enable = true;
  };

  # #~ colors ~#
  # colors = {
  #   activeColor = config.lib.stylix.colors.withHashtag.base02;
  #   backgroundColor = config.lib.stylix.colors.withHashtag.base00;
  #   inactiveColor = config.lib.stylix.colors.withHashtag.base0F;
  #   inactiveColor2 = config.lib.stylix.colors.withHashtag.base0D;
  #   urgentColor = "#FF0000";
  #   textColor = config.lib.stylix.colors.withHashtag.base07;
  # };

  ########################################
  #
  ## Source Files
  #
  ########################################
  home.file = { };

  ########################################
  #
  ## Variables
  #
  ########################################
  home.sessionVariables = {
    EDITOR = "vim";
    SYSTEMD_EDITOR = "vim";
  };

  ########################################
  #
  ## Program Configurations and Imports
  #
  ########################################
  imports = [
    ./ags # AGS Notification Daemon Configuration
    ./alacritty # Alacritty Terminal Configuration
    ./gtklock # GTKLock Configuration
    ./mangohud # MangoHud Configuration
    ./mpv # MPV Media Player Configuration
    ./packages # Custom Package Configuration
    ./rofi # Rofi Configuration
    ./sway # Sway Window Manager Configuration
    # ./swaync # Sway Notification Center Configuration
    ./waybar # Waybar Configuration
    ./wtf # WTFUtil Configuration
    ./zathura # Zathura PDF Viewer Configuration
    ./zsh # ZSH Shell Configuration
  ];

  ########################################
  #
  ## Home Activation
  #
  ########################################
  #   home.activation = {
  #     postInstall = ''
  #       $SHELL -c "fisher install ilancosman/tide" &>/dev/null
  #       $SHELL -c "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Dotted --prompt_connection_andor_frame_color=Lightest --prompt_spacing=Sparse --icons='Many icons' --transient=Yes" &>/dev/null
  #     '';
  #   };
}
