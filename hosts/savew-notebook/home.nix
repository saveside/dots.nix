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
    (config.lib.nixGL.wrap imagemagick)
    (config.lib.nixGL.wrap nwg-displays)
    (flameshot.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "flameshot-org";
        repo = "flameshot";
        rev = "10d12e0";
        sha256 = "sha256-3ujqwiQrv/H1HzkpD/Q+hoqyrUdO65gA0kKqtRV0vmw=";
      };
      cmakeFlags = [
        "-DUSE_WAYLAND_CLIPBOARD=1"
        "-DUSE_WAYLAND_GRIM=1"
      ];
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.libsForQt5.kguiaddons ];
    }))
    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "JetBrainsMono"
      ];
    })
    ags
    alacritty-theme
    ansible
    bat
    bat-extras.batman
    bibata-cursors
    btop
    bun
    evince
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
    neovim
    nixd
    nixfmt-classic
    nmap
    nvtopPackages.amd
    nwg-look
    pcmanfm-qt
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

  #~ packages ~#
  pkgconfig = {
    alacritty = {
      enable = true;
      theme = "monokai_charcoal";
    };
    zsh.enable = true;
    gtklock.enable = true;
    mpv.enable = true;
    # swappy.enable = true;
    sway.enable = true;
    # swaylock.enable = true;
    # swaynag.enable = true;
    # tmux.enable = true;
    wtf.enable = true;
    waybar.enable = true;
    rofi.enable = true;
    zathura.enable = true;
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
    # ./fontconfig # fontconfig Configuration
    ./gtklock # gtklock Configuration
    # ./mangohud # mangohud Configuration
    ./mpv # MPV Media Player Configuration
    ./wtf # WTF Util Configuration
    ./rofi # Rofi Configuration
    ./sway # Sway Window Manager Configuration
    # ./swaync # Sway Notification Center Configuration
    ./waybar # Waybar Configuration
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
