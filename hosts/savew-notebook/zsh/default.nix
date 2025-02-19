{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.pkgconfig.zsh = {
    enable = lib.mkEnableOption "Enable zsh configuration.";
  };
  config.programs.zsh = {
    enable = config.pkgconfig.zsh.enable;
    package = pkgs.zsh;
    autosuggestion.enable = true;
    shellAliases = {
      c = "clear";
      cat = "${pkgs.bat}/bin/bat";
      download = "${pkgs.yt-dlp}/bin/yt-dlp --format 'bestvideo[height<=1080]+bestaudio'";
      fixmouse = "echo 'on' | sudo tee '/sys/bus/usb/devices/1-2/power/control'";
      gamerun = "mesa_glthread=true gamemoderun";
      gia = "git add .";
      gica = "git commit -a";
      ironweil = "mesa_glthread=true gamemoderun ironwail -basedir $HOME/.vkquake";
      ls = "${pkgs.eza}/bin/eza";
      mp3 = "${pkgs.yt-dlp}/bin/yt-dlp -x --audio-format mp3";
      rsync = "${pkgs.rsync}/bin/rsync -avz --progress --partial --human-readable";
      tldr = "cht.sh";
      upload = "sh $HOME/.config/sway/scripts.d/paste.sh";
      v = "${pkgs.neovide}/bin/neovide --multigrid";
      vim = "${pkgs.neovim}/bin/nvim";
      yt = "${pkgs.yt-dlp}/bin/yt-dlp --format 'bestvideo[height<=1080]+bestaudio'";
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
    sessionVariables = {
      PAGER = "most";
      LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
      GHCUP_USE_XDG_DIRS = "true";
      GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
      LANGUAGE = "en_US.UTF-8";
      GPG_TTY = "$(tty)";
      HISTFILE = "$HOME/.zsh_history";
      VISUAL = "${pkgs.neovim}/bin/nvim";
    };
  };

}
