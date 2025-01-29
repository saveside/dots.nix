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
  nixGL.packages = inputs.nixgl.packages;

  ########################################
  #
  ## Packages
  #
  ########################################
  home.packages = with pkgs; [
    (config.lib.nixGL.wrap imagemagick)
    (config.lib.nixGL.wrap nwg-displays)
    ags
    alacritty-theme
    ansible
    bat
    bat-extras.batman
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
    nerdfonts
    nixd
    nixfmt-classic
    nmap
    nvtopPackages.amd
    nwg-look
    pcmanfm-qt
    rofi-wayland
    sass
    scrcpy
    slurp
    swappy
    swaybg
    swayfx
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
    wtype
    ydotool
    yq
    yt-dlp
    zsh
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
    # fastfetch.enable = true;
    # fish.enable = true;
    # mako.enable = true;
    # mangohud.enable = true;
    # mpv.enable = true;
    # swappy.enable = true;
    # sway.enable = true;
    # swaylock.enable = true;
    # swaynag.enable = true;
    # tmux.enable = true;
    # waybar.enable = true;
    # wofi.enable = true;
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
    # ./ags # AGS Notification Daemon Configuration
    ./alacritty # Alacritty Terminal Configuration
    # ./fastfetch # Fastfetch Configuration
    # ./fontconfig # fontconfig Configuration
    # ./gtklock # gtklock Configuration
    # ./mangohud # mangohud Configuration
    # ./mpv # MPV Media Player Configuration
    # ./rofi # Rofi Configuration
    # ./sway # Sway Window Manager Configuration
    # ./swaync # Sway Notification Center Configuration
    # ./tmux # TMUX Terminal Multiplexer Configuration
    # ./waybar # Waybar Configuration
    # ./zathura # Zathura PDF Viewer Configuration
    # ./zsh # ZSH Shell Configuration
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