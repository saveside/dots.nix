{ config, lib, ... }:

let
  cfg = config.moduleopts.mangohud;
in
{
  options.moduleopts.mangohud = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "mangohud";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      enable = true;

      settings = {
        cpu_load_change = true;
        cpu_mhz = true;
        cpu_power = true;
        cpu_stats = true;
        cpu_temp = true;
        font_size = lib.mkForce (config.stylix.fonts.sizes.applications + 7);
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
  };
}
