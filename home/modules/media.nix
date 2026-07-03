# Media configuration (mpd, ncmpcpp, rmpc, mpv, yt-dlp)
{
  config,
  lib,
  pkgs,
  ...
}:

let
  home = config.home.homeDirectory;
in
{
  #############################################################################
  # MPD (Music Player Daemon)
  #############################################################################

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    playlistDirectory = "${config.home.homeDirectory}/.mpd/playlists";
    dbFile = "${config.home.homeDirectory}/.mpd/mpd.db";

    network = {
      listenAddress = "127.0.0.1";
      port = 6600;
    };

    extraConfig = ''
      log_file           "${config.home.homeDirectory}/.mpd/mpd.log"
      pid_file           "${config.home.homeDirectory}/.mpd/mpd.pid"
      state_file         "${config.home.homeDirectory}/.mpd/mpdstate"

      audio_output {
          type           "alsa"
          name           "Alsa for audio sound card"
          mixer_device   "default"
          mixer_control  "Master"
      }

      audio_output {
          type           "fifo"
          name           "my_fifo"
          path           "/tmp/mpd.fifo"
          format         "44100:16:2"
      }
    '';
  };

  home.activation = {
    createMpdDir = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ${config.home.homeDirectory}/.mpd/playlists
    '';
  };

  services.mpd-discord-rpc.enable = true;

  #############################################################################
  # ncmpcpp
  #############################################################################

  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };

    settings = {
      # Connection
      mpd_host = "127.0.0.1";
      mpd_port = 6600;
      mpd_connection_timeout = "5";
      mpd_crossfade_time = "5";
      mpd_music_dir = "~/Music";

      # Visualizer
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = "yes";
      visualizer_fps = "60";
      visualizer_type = "ellipse";
      visualizer_look = "●●";
      visualizer_color = "magenta,cyan,blue,red,white,green,yellow,black,magenta";
      visualizer_spectrum_smooth_look = "yes";

      # General UI
      connected_message_on_startup = "yes";
      cyclic_scrolling = "yes";
      mouse_support = "no";
      mouse_list_scroll_whole_page = "yes";
      lines_scrolled = "1";
      message_delay_time = "1";
      playlist_shorten_total_times = "yes";
      playlist_display_mode = "columns";
      browser_display_mode = "columns";
      search_engine_display_mode = "columns";
      playlist_editor_display_mode = "columns";
      autocenter_mode = "yes";
      centered_cursor = "yes";
      user_interface = "classic";
      follow_now_playing_lyrics = "yes";
      locked_screen_width_part = "50";
      ask_for_locked_screen_width_part = "yes";
      display_bitrate = "no";
      external_editor = "nano";
      main_window_color = "default";
      startup_screen = "browser";

      # Progress Bar
      progressbar_look = "▪▪▪";
      progressbar_elapsed_color = "magenta";
      progressbar_color = "black";

      # UI Visibility
      header_visibility = "no";
      statusbar_visibility = "yes";
      titles_visibility = "yes";
      enable_window_title = "yes";

      # Colors
      statusbar_color = "white";
      color1 = "white";
      color2 = "blue";

      # Formatting Strings
      now_playing_prefix = "$b$2$7 ";
      now_playing_suffix = "  $/b$8";
      current_item_prefix = "$b$7$/b$3 ";
      current_item_suffix = "  $8";

      song_columns_list_format = "(50)[]{t|fr:Title} (0)[magenta]{a}";
      song_list_format = " {%t $R   $8%a$8}|{%f $R   $8%l$8} $8";
      song_status_format = "$b$2 $7 {$b$6$8 %t $6} $7 $8";
      song_window_title_format = "Now Playing ..";
    };
  };

  #############################################################################
  # rmpc (Rust MPD Client)
  #############################################################################

  programs.rmpc = {
    enable = true;
    config = ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      #![enable(unwrap_variant_newtypes)]
      (
          address: "127.0.0.1:6600",
          password: None,
          theme: None,
          cache_dir: None,
          on_song_change: None,
          volume_step: 5,
          max_fps: 30,
          scrolloff: 0,
          wrap_navigation: false,
          enable_mouse: true,
          enable_config_hot_reload: true,
          status_update_interval_ms: 1000,
          rewind_to_start_sec: None,
          reflect_changes_to_playlist: false,
          select_current_song_on_change: false,
          browser_song_sort: [Disc, Track, Artist, Title],
          directories_sort: SortFormat(group_by_type: true, reverse: false),
          scrollbar: (
              symbols: ["│", "█", "▲", "▼"],
          ),
          album_art: (
              method: Auto,
              max_size_px: (width: 1200, height: 1200),
              disabled_protocols: ["http://", "https://"],
              vertical_align: Center,
              horizontal_align: Center,
          ),
          keybinds: (
              global: {
                  ":":       CommandMode,
                  ",":       VolumeDown,
                  "s":       Stop,
                  ".":       VolumeUp,
                  "<Tab>":   NextTab,
                  "<S-Tab>": PreviousTab,
                  "1":       SwitchToTab("Queue"),
                  "2":       SwitchToTab("Directories"),
                  "3":       SwitchToTab("Artists"),
                  "4":       SwitchToTab("Album Artists"),
                  "5":       SwitchToTab("Albums"),
                  "6":       SwitchToTab("Playlists"),
                  "7":       SwitchToTab("Search"),
                  "q":       Quit,
                  ">":       NextTrack,
                  "p":       TogglePause,
                  "<":       PreviousTrack,
                  "f":       SeekForward,
                  "z":       ToggleRepeat,
                  "x":       ToggleRandom,
                  "c":       ToggleConsume,
                  "v":       ToggleSingle,
                  "b":       SeekBack,
                  "~":       ShowHelp,
                  "u":       Update,
                  "U":       Rescan,
                  "I":       ShowCurrentSongInfo,
                  "O":       ShowOutputs,
                  "P":       ShowDecoders,
                  "R":       AddRandom,
              },
              navigation: {
                  "k":          Up,
                  "j":          Down,
                  "h":          Left,
                  "l":          Right,
                  "<Up>":       Up,
                  "<Down>":     Down,
                  "<Left>":     Left,
                  "<Right>":    Right,
                  "<C-k>":      PaneUp,
                  "<C-j>":      PaneDown,
                  "<C-h>":      PaneLeft,
                  "<C-l>":      PaneRight,
                  "<C-u>":      UpHalf,
                  "N":          PreviousResult,
                  "a":          Add,
                  "A":          AddAll,
                  "r":          Rename,
                  "n":          NextResult,
                  "g":          Top,
                  "<Space>":    Select,
                  "<C-Space>":  InvertSelection,
                  "G":          Bottom,
                  "<CR>":       Confirm,
                  "i":          FocusInput,
                  "J":          MoveDown,
                  "<C-d>":      DownHalf,
                  "/":          EnterSearch,
                  "<C-c>":      Close,
                  "<Esc>":      Close,
                  "K":          MoveUp,
                  "D":          Delete,
                  "B":          ShowInfo,
              },
              queue: {
                  "D":       DeleteAll,
                  "<CR>":    Play,
                  "<C-s>":   Save,
                  "a":       AddToPlaylist,
                  "d":       Delete,
                  "C":       JumpToCurrent,
                  "X":       Shuffle,
              },
          ),
          search: (
              case_sensitive: false,
              mode: Contains,
              tags: [
                  (value: "any",          label: "Any Tag"),
                  (value: "artist",       label: "Artist"),
                  (value: "album",        label: "Album"),
                  (value: "albumartist", label: "Album Artist"),
                  (value: "title",        label: "Title"),
                  (value: "filename",     label: "Filename"),
                  (value: "genre",        label: "Genre"),
              ],
          ),
          artists: (
              album_display_mode: SplitByDate,
              album_sort_by: Date,
          ),
          tabs: [
              (
                  name: "Queue",
                  pane: Split(
                      direction: Horizontal,
                      panes: [
                          (size: "40%", pane: Pane(AlbumArt)),
                          (size: "60%", pane: Split(
                              direction: Vertical,
                              panes: [
                                  (size: "50%", pane: Pane(Queue)),
                                  (size: "50%", pane: Pane(Cava)),
                              ],
                          )),
                      ],
                  ),
              ),
              ( name: "Directories", pane: Pane(Directories) ),
              ( name: "Artists", pane: Pane(Artists) ),
              ( name: "Album Artists", pane: Pane(AlbumArtists) ),
              ( name: "Albums", pane: Pane(Albums) ),
              ( name: "Playlists", pane: Pane(Playlists) ),
              ( name: "Search", pane: Pane(Search) ),
          ],
          cava: (
              framerate: 60,
              autosens: true,
              sensitivity: 100,
              lower_cutoff_freq: 50,
              higher_cutoff_freq: 10000,
              input: (
                  method: Fifo,
                  source: "/tmp/mpd.fifo",
                  sample_rate: 44100,
                  channels: 2,
                  sample_bits: 16,
              ),
              smoothing: (
                  noise_reduction: 77,
                  monstercat: false,
                  waves: false,
              ),
              eq: []
          ),
      )
    '';
  };

  #############################################################################
  # mpv
  #############################################################################

  programs.mpv.enable = true;
  xdg.configFile."mpv" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "Tsubajashi";
      repo = "mpv-settings";
      rev = "f859a9a";
      sha256 = "sha256-Wie8FLDvfHCHdF4aa1EW9Bd71kuViFfhUek0MY8kHCw=";
    };
  };

  #############################################################################
  # yt-dlp
  #############################################################################

  programs.yt-dlp.enable = true;

  xdg.configFile."yt-dlp/music/yt-dlp.conf".text = ''
    --convert-thumbnails jpg
    --embed-metadata
    --embed-thumbnail
    --exec ${home}/.config/yt-dlp/music/modify-and-trim-nonstandard-characters.sh
    --no-mtime
    --ppa "ffmpeg: -c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\""
    --parse-metadata "playlist_index:%(track_number)s"
    --parse-metadata "%(release_year|)s:%(meta_date)s"
    --parse-metadata "track:(?i)(?P<track>.+)s+(?:([^)]*(?:master|edition|original|mix)[^)]*))s*"
    --parse-metadata "album:(?i)(?P<album>.+)s+(?:([^)]*(?:master|edition)[^)]*))s*"
    --replace-in-metadata 'artist' ',.+' ""
    -f 251
    -x
    -N 8
  '';

  xdg.configFile."yt-dlp/music/modify-and-trim-nonstandard-characters.sh" = {
    executable = true;
    text = ''
      #!${lib.getExe pkgs.bash}
      OLDIFS=$IFS
      IFS=$'\n'
      YELLOW='\033[1;33m'
      GREEN='\033[0;32m'
      NC='\033[0m'

      for f in $(find ${home}/Music -depth -name '*[ğüşıöçĞÜŞİÖÇâîûêôÂÎÛÊÔ⧸？&]*'); do
        new=$(echo "$f" | awk -F '/' '{print $NF}' | sed 's/&/feat./g; s/？//g; s/⧸/-/g')
        new=$(basename "$new" | sed 'y/ğüşıöçĞÜŞİÖÇâîûêôÂÎÛÊÔ/gusiocGUSIOCaiueoAIUEO/')
        new_filename=$(echo "$f" | sed "s/$(basename "$f")/$new/")
        if [[ -d "$new_filename" ]]; then
          cp -R "$f"/* "$new_filename"/
          [[ "$?" == "0" ]] && rm -rf "$f"
          [[ -d "$new_filename" ]] && echo -e "''${YELLOW}Merged contents of \"$f\" to \"$new_filename\"''${NC}"
        elif [[ "$new_filename" != "$f" ]] && [[ ! -f "$new_filename" ]]; then
          mv "$f" "$new_filename"
          [[ -f "$new_filename" ]] && echo -e "''${YELLOW}Renamed \"$f\" to \"$new_filename\"''${NC}"
        fi
      done
      IFS=$OLDIFS
      echo -e "''${GREEN}Renaming process finished.''${NC}"
    '';
  };
}
