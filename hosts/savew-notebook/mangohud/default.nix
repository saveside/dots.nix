{ config, lib, ... }:

{
  options.pkgconfig.mangohud = {
    enable = lib.mkEnableOption "Enable mangohud configuration.";
  };
  config.programs.mangohud = {
    enable = config.pkgconfig.mangohud.enable;

    settings = {
      cpu_stats = true;
      cpu_temp = true;
      fps = true;
      frametime = true;
      frame_timing = true;
      gpu_core_clock = true;
      gpu_power = true;
      gpu_fan = true;
      gpu_stats = true;
      gpu_temp = true;
      ram = true;
      time = true;
      text_outline = true;
      throttling_status = true;
      vram = true;
    };
  };
}
