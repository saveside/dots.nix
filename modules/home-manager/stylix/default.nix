{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [ inputs.stylix.homeManagerModules.stylix ];

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
    image = inputs.self + "/assets/wallpaper";
    polarity = "dark";
    targets = {
      alacritty.enable = false;
      mako.enable = false;
      mangohud.enable = false;
      hyprland.enable = false;
      k9s.enable = false;
      kde.enable = false;
      neovim.enable = false;
      nixvim.enable = false;
      qt.enable = false;
      rofi.enable = false;
      sway.enable = false;
      swaylock.enable = false;
      swaync.enable = false;
      waybar.enable = false;
      wofi.enable = false;
      zathura.enable = false;
    };
  };
}
