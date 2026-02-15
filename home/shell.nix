# Shell configuration (zsh + starship)
{
  lib,
  pkgs,
  ...
}:

{
  #############################################################################
  # Zsh
  #############################################################################

  programs.zsh = {
    enable = true;
    history = {
      size = 500000;
      save = 500000;
      path = "$XDG_STATE_HOME/zsh/history";
      share = true;
      ignoreDups = true;
      extended = true;
    };

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
      vim = "nvim";
      yt = "${lib.getExe pkgs.yt-dlp} --format 'bestvideo[height<=1080]+bestaudio'";
      k = "kubectl";
      ff = "fastfetch";
      rebuild = "sudo nixos-rebuild switch --flake .#notebook";
      music = " yt-dlp --config-location ~/.config/yt-dlp/music/yt-dlp.conf";
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
      extraConfig = ''
        zstyle ':omz:update' mode auto
        zstyle ':omz:update' frequency 13
        export HIST_STAMPS="mm/dd/yyyy"
      '';
    };

    initContent = ''
      [[ -s "${pkgs.grc}/etc/grc.zsh" ]] && source "${pkgs.grc}/etc/grc.zsh"
      
      [[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"
      
      # Manual opt set for APPEND_HISTORY (though Nix history options cover most)
      setopt APPEND_HISTORY
    '';
  };

  programs.fzf.enableZshIntegration = true;

  #############################################################################
  # Starship Prompt
  #############################################################################

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
