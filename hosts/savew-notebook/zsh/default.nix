{
  config,
  lib,
  pkgs,
  inputs,
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
      cat = "bat";
      download = "yt-dlp --format 'bestvideo[height<=1080]+bestaudio'";
      fixmouse = "su -c 'echo 'on' > '/sys/bus/usb/devices/1-2/power/control''";
      gamerun = "mesa_glthread=true gamemoderun";
      gia = "git add .";
      gica = "git commit -a";
      ironweil = "mesa_glthread=true gamemoderun ironwail -basedir ~/.vkquake";
      ls = "eza";
      mp3 = "yt-dlp -x --audio-format mp3";
      pass = "md5sum";
      rsync = "rsync -avz --progress --partial --human-readable";
      tldr = "cht.sh";
      upload = "sh /home/savew/Scripts/paste.sh";
      v = "neovide --multigrid";
      vim = "nvim";
      wget = "wget --hsts-file=\"$XDG_DATA_HOME/wget-hsts\"";
      xdpreload = "sudo xdp-loader unload -a wlan0; sudo xdp-loader load -m skb -s prog wlan0 obj/icmp_block.o";
      yt = "yt-dlp --format 'bestvideo[height<=1080]+bestaudio'";
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
      HISTFILE = "~/.zsh_history";
      VISUAL = "nvim";
    };
  };

}
