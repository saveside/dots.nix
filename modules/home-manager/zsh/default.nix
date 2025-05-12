{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.moduleopts.zsh;
  home = config.home.homeDirectory;
in
{
  options.moduleopts.zsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "zsh";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      initContent = lib.mkOrder 500 ''
        export PATH="${home}/.local/share/JetBrains/Toolbox/scripts:${home}/.local/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:${home}/.nix-profile/sbin:${home}/.nix-profile/bin:$PATH";
        export XDG_DATA_DIRS="${home}/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:${home}/.local/share:/usr/local/share:/usr/share:${home}/.nix-profile/share:$XDG_DATA_DIRS";
      '';
      shellAliases = {
        c = "clear";
        download = "${lib.getExe pkgs.yt-dlp} --format 'bestvideo[height<=1080]+bestaudio'";
        fixmouse = "echo 'on' | sudo tee '/sys/bus/usb/devices/1-2/power/control'";
        gia = "${lib.getExe pkgs.git} add .";
        gica = "${lib.getExe pkgs.git} commit -a";
        ls = "${lib.getExe pkgs.eza}";
        mp3 = "${lib.getExe pkgs.yt-dlp} -x --audio-format mp3";
        rsync = "${lib.getExe pkgs.rsync} -avz --progress --partial --human-readable";
        tldr = "${lib.getExe pkgs.cht-sh}";
        v = "${lib.getExe pkgs.neovide} --multigrid";
        vim = "${lib.getExe pkgs.neovim}";
        yt = "${lib.getExe pkgs.yt-dlp} --format 'bestvideo[height<=1080]+bestaudio'";
        yt-album = "${lib.getExe pkgs.yt-dlp} -o \"${config.home.homeDirectory}/Music/Albums/%(album)s - %(artist)s/%(playlist_autonumber)02d - %(track)s.%(ext)s\"";
        yt-music = "${lib.getExe pkgs.yt-dlp} -o \"${config.home.homeDirectory}/Music/Artists/%(artist)s/%(album)s/%(title)s.%(ext)s\"";
        k = "kubectl";
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
