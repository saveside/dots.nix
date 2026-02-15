# NVIDIA GPU configuration for notebook
{ lib, config, pkgs, ... }:

{
  options.hardware.nvidia.enable = lib.mkEnableOption "NVIDIA GPU support";

  config = lib.mkMerge [
    { }

    (lib.mkIf config.hardware.nvidia.enable {
      services.xserver.videoDrivers = [
        "nvidia"
        "modesetting"
      ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-vaapi-driver
          intel-media-driver
          libvdpau-va-gl
        ];
      };

      hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        };
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };
    })
  ];
}
