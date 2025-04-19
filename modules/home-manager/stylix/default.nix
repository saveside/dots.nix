{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [ inputs.stylix.homeManagerModules.stylix ];

  options.colors = {
    activeColor = lib.mkOption {
      default = config.lib.stylix.colors.withHashtag.base0C;
      type = lib.types.str;
    };
    backgroundColor = lib.mkOption {
      default = config.lib.stylix.colors.withHashtag.base00;
      type = lib.types.str;
    };
    inactiveColor = lib.mkOption {
      default = config.lib.stylix.colors.withHashtag.base01;
      type = lib.types.str;
    };
    inactiveColor2 = lib.mkOption {
      default = config.lib.stylix.colors.withHashtag.base02;
      type = lib.types.str;
    };
    urgentColor = lib.mkOption {
      default = "#FF0000";
      type = lib.types.str;
    };
    textColor = lib.mkOption {
      default = config.lib.stylix.colors.withHashtag.base0F;
      type = lib.types.str;
    };
  };

  config.stylix = {
    enable = true;
    # autoEnable = false;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      sansSerif = {
        name = "SFProDisplay Nerd Font";
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
      };
      serif = {
        name = "SFProDisplay Nerd Font";
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
      };
      sizes = {
        applications = 8;
        terminal = 10;
      };
    };
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      light = "Papirus-Dark";
      dark = "Papirus-Dark";
    };
    image = inputs.self + /assets/wallpaper;
    polarity = "dark";
    targets = {
      alacritty.enable = false;
      gnome.enable = false;
      gtk.enable = false;
      hyprland.enable = false;
      k9s.enable = false;
      kde.enable = false;
      mangohud.enable = false;
      neovim.enable = false;
      qt.enable = false;
      rofi.enable = false;
      sway.enable = false;
      swaylock.enable = false;
      swaync.enable = false;
      waybar.enable = false;
      zathura.enable = false;
    };
  };
}
