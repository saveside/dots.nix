# Desktop tools configuration (htop, yazi, mangohud, rnnoise, flatpak)
{
  lib,
  pkgs,
  ...
}:

{
  #############################################################################
  # htop
  #############################################################################

  programs.htop = {
    enable = true;
    settings = {
      # General Settings
      fields = [
        0
        48
        17
        18
        39
        40
        2
        46
        47
        49
        1
      ];
      hide_kernel_threads = 0;
      hide_userland_threads = 1;
      shadow_other_users = 1;
      show_thread_names = 0;
      show_program_path = 0;
      highlight_base_name = 1;
      highlight_megabytes = 1;
      highlight_threads = 1;

      # Display & CPU
      show_cpu_usage = 1;
      show_cpu_frequency = 1;
      show_cpu_temperature = 1;
      show_cached_memory = 1;
      detailed_cpu_time = 0;

      # Interface
      color_scheme = 0;
      enable_mouse = 1;
      delay = 7;
      header_layout = "two_50_50";

      # Meters (Left Column)
      column_meters_0 = [
        "System"
        "NetworkIO"
        "DiskIO"
        "Tasks"
        "LoadAverage"
        "Uptime"
        "Blank"
        "Memory"
        "Swap"
      ];
      column_meter_modes_0 = [
        2
        2
        2
        2
        2
        2
        2
        1
        1
      ];

      # Meters (Right Column)
      column_meters_1 = [
        "GPU"
        "CPU"
        "AllCPUs2"
      ];
      column_meter_modes_1 = [
        1
        1
        1
      ];

      # Sorting
      sort_key = 49; # TIME
      sort_direction = -1;
      tree_view = 0;
    };
  };

  #############################################################################
  # Yazi (file manager)
  #############################################################################

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    initLua = ./tools/yazi/init.lua;
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "<C-n>";
          run = ''shell '${lib.getExe pkgs.dragon-drop} -x -i -T "$@" 2>/dev/null &' --confirm'';
        }
        {
          on = [
            "y"
            "y"
          ];
          run = [ "plugin wl-clipboard" ];
        }
        {
          on = [
            "g"
            "i"
          ];
          run = "plugin lazygit";
          desc = "run lazygit";
        }
        {
          on = "u";
          run = "plugin restore";
          desc = "Restore last deleted files/folders";
        }
        {
          on = "M";
          run = "plugin mount";
        }
        {
          on = "T";
          run = "shell footclient -T yazi zsh";
          desc = "Open terminal at current dir";
        }
      ];
    };
    plugins = {
      inherit (pkgs.yaziPlugins) mount wl-clipboard lazygit restore;
    };
  };

  #############################################################################
  # MangoHud (gaming overlay)
  #############################################################################

  programs.mangohud = {
    enable = true;
    settings = {
      cpu_load_change = true;
      cpu_mhz = true;
      cpu_power = true;
      cpu_stats = true;
      cpu_temp = true;
      font_size = 20;
      fps = true;
      gpu_core_clock = true;
      gpu_mem_clock = true;
      gpu_name = true;
      gpu_power = true;
      gpu_stats = true;
      gpu_temp = true;
      position = "top-left";
      ram = true;
      resolution = true;
      swap = true;
      time = true;
      vkbasalt = true;
      vram = true;
    };
  };

  #############################################################################
  # RNNoise (noise cancellation)
  #############################################################################

  xdg.configFile."pipewire/pipewire.conf.d/99-input-denoising.conf".text = ''
    context.modules = [
      {
        name = libpipewire-module-filter-chain
        args = {
          node.description = "Noise Canceling source"
          media.name = "Noise Canceling source"

          filter.graph = {
            nodes = [
              {
                type = ladspa
                name = rnnoise
                plugin = ${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so
                label = noise_suppressor_mono
                control = {
                  "VAD Threshold (%)" = 50.0
                  "VAD Grace Period (ms)" = 200
                  "Retroactive VAD Grace (ms)" = 0
                }
              }
            ]
          }

          capture.props = {
            node.name = "capture.rnnoise_source"
            node.passive = true
            audio.rate = 48000
          }

          playback.props = {
            node.name = "rnnoise_source"
            media.class = Audio/Source
            audio.rate = 48000
          }
        }
      }
    ]
  '';

  #############################################################################
  # Flatpak
  #############################################################################

  services.flatpak = {
    enable = true;
    packages = [
      "org.vinegarhq.Sober"
      "com.stremio.Stremio"
    ];
    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
        args = "--user --prio=5";
      }
    ];
  };
}
