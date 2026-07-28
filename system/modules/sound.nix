# PipeWire audio stack
{ config, lib, ... }:

let
  cfg = config.cfg.sound;
in
{
  options.cfg.sound.enable = lib.mkEnableOption "PipeWire audio";

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
}
