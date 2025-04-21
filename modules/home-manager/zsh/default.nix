{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.moduleopts.zsh;
in
{
  options.moduleopts.zsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Hyprland";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      shellAliases = {
        c = "clear";
        download = "${lib.getExe pkgs.yt-dlp} --format 'bestvideo[height<=1080]+bestaudio'";
        fixmouse = "echo 'on' | sudo tee '/sys/bus/usb/devices/1-2/power/control'";
        gia = "git add .";
        gica = "git commit -a";
        ls = "${lib.getExe pkgs.eza}";
        mp3 = "${lib.getExe pkgs.yt-dlp} -x --audio-format mp3";
        rsync = "${lib.getExe pkgs.rsync} -avz --progress --partial --human-readable";
        tldr = "${lib.getExe pkgs.cht-sh}";
        v = "${lib.getExe pkgs.neovide} --multigrid";
        vim = "${lib.getExe pkgs.neovim}";
        yt = "${lib.getExe pkgs.yt-dlp} --format 'bestvideo[height<=1080]+bestaudio'";
        yt-album = "yt-dlp -o \"${config.home.homeDirectory}/Music/Albums/%(album)s - %(artist)s/%(playlist_autonumber)02d - %(track)s.%(ext)s\"";
        yt-music = "yt-dlp -o \"${config.home.homeDirectory}/Music/Artists/%(artist)s/%(album)s/%(title)s.%(ext)s\"";
      };
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions.src;
        }
        {
          name = "zsh-fzf-history-search";
          src = pkgs.zsh-fzf-history-search.src;
        }
        {
          name = "F-Sy-H";
          src = pkgs.zsh-f-sy-h.src;
        }
      ];
      oh-my-zsh = {
        enable = true;
        theme = "dst";
        plugins = [
          "git"
          "dotenv"
        ];
      };
    };
  };
}
