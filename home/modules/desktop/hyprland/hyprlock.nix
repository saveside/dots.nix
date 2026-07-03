{ ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
        text_trim = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 4;
          contrast = 1.5916;
          brightness = 1.0172;
          vibrancy = 1.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          size = "250, 60";
          outline_thickness = 0;
          dots_size = 0.1;
          dots_spacing = 1.0;
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 1.0)";
          inner_color = "rgba(0, 0, 0, 1.0)";
          font_color = "rgba(200, 200, 200, 1.0)";
          fade_on_empty = false;
          font_family = "JetBrains Mono Nerd Font Mono";
          placeholder_text = "<span> $USER</span>";
          hide_input = false;
          position = "0, -470";
          halign = "center";
          valign = "center";
          zindex = 10;
        }
      ];

      label = [
        {
          text = "cmd[update:1000] echo -e \"$(date +\"%H\")\"";
          color = "rgba(255, 255, 255, 1.0)";
          font_size = 150;
          font_family = "AlfaSlabOne";
          position = "0, -250";
          halign = "center";
          valign = "top";
          shadow_size = 3;
          shadow_color = "rgb(0,0,0)";
          shadow_boost = 1.2;
        }
        {
          text = "cmd[update:1000] echo -e \"$(date +\"%M\")\"";
          color = "rgba(255, 255, 255, 1.0)";
          font_size = 150;
          font_family = "AlfaSlabOne";
          position = "0, -420";
          halign = "center";
          valign = "top";
        }
        {
          text = "cmd[update:1000] echo -e \"$(date +\"%d %b %A\")\"";
          color = "rgba(255, 255, 255, 1.0)";
          font_size = 14;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:1000] echo \"$(bash ~/.config/hypr/bin/location.sh) $(bash ~/.config/hypr/bin/weather.sh)\"";
          color = "rgba(255, 255, 255, 1.0)";
          font_size = 10;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "0, 465";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:1000] echo \"$(~/.config/hypr/bin/playerctlock.sh --title)\"";
          color = "rgba(255, 255, 255, 0.8)";
          font_size = 12;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "880, -290";
          halign = "left";
          valign = "center";
        }
      ];

      image = [
        {
          path = "~/.cache/playerctlock-art/latest.png";
          size = 60;
          rounding = 5;
          border_size = 0;
          reload_time = 1;
          reload_cmd = "~/.config/hypr/bin/playerctlock.sh --arturl";
          position = "-150, -300";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
