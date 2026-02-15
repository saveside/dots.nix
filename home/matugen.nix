{ config, pkgs, inputs, ... }:

{
  imports = [
    # Changed from nixosModules to homeManagerModules
    inputs.matugen.nixosModules.default
  ];

  # Add Matugen package to your environment
  home.packages = [ 
    inputs.matugen.packages.${pkgs.system}.default 
  ];

  programs.matugen = {
    enable = true;
    variant = "dark";

    # Removed the 'settings' wrapper. Options are now direct children of 'programs.matugen'
    config = {
      reload_apps = true;
      reload_apps_list = {
        kitty = true;
        gtk_theme = true;
      };
    };

    # Custom Colors
    custom_colors = {
      red = { color = "#FF0000"; blend = true; };
      green = { color = "#00FF00"; blend = true; };
      yellow = { color = "#FFFF00"; blend = true; };
      blue = { color = "#0000FF"; blend = true; };
      magenta = { color = "#FF00FF"; blend = true; };
      cyan = { color = "#00FFFF"; blend = true; };
      white = { color = "#FFFFFF"; blend = true; };
    };

    # Templates
    templates = {
      rofi-spotlight = {
        input_path = "${./templates/rofi-spotlight.rasi}";
        output_path = "~/.config/rofi/themes/spotlight-dark-matugen.rasi";
      };
      waybar = {
        input_path = "${./templates/waybar}";
        output_path = "~/.config/waybar/colors.css";
        post_hook = "pkill -SIGUSR2 waybar";
      };
      ghostty = {
        input_path = "${./templates/ghostty}";
        output_path = "~/.config/ghostty/themes/matugen";
      };
      slurp = {
        input_path = "${./templates/colors-slurp.sh}";
        output_path = "~/.config/kitty/slurp.sh";
      };
      gtk3 = {
        input_path = "${./templates/colors.css}";
        output_path = "~/.config/gtk-3.0/colors.css";
      };
      gtk4 = {
        input_path = "${./templates/colors.css}";
        output_path = "~/.config/gtk-4.0/colors.css";
      };
      nvim = {
        input_path = "${./templates/base46.lua}";
        output_path = "~/.cache/wal/base46-dark.lua";
      };
      discord = {
        input_path = "${./templates/discord-colors.theme.css}";
        output_path = "~/.config/vesktop/themes/axmat.theme.css";
      };
      pywalsh = {
        input_path = "${./templates/colors.sh}";
        output_path = "~/.cache/wal/colors.sh";
        post_hook = "walogram -B > /dev/null 2>&1 &";
      };
      pywalwalfile = {
        input_path = "${./templates/wal}";
        output_path = "~/.cache/wal/wal";
      };
      rofi = {
        input_path = "${./templates/colors-rofi.rasi}";
        output_path = "~/.cache/wal/colors-rofi.rasi";
      };
      zathura = {
        input_path = "${./templates/colors-zathura}";
        output_path = "~/.config/zathura/zathurarc";
      };
      yazi = {
        input_path = "${./templates/colors-yazi.toml}";
        output_path = "~/.config/yazi/theme.toml";
      };
      hyprland = {
        input_path = "${./templates/hyprland-colors.conf}";
        output_path = "~/.config/hypr/modules/colors.conf";
      };
      alacritty = {
        input_path = "${./templates/alacritty.toml}";
        output_path = "~/.config/alacritty/colors.toml";
      };
      tty = {
        input_path = "${./templates/pywal-colors.json}";
        output_path = "~/.cache/wal/colors-tty.sh";
        post_hook = "sh ${./scripts/tty_generator.sh} ~/.cache/wal/colors-tty.sh";
      };
    };
  };
}
