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

}
