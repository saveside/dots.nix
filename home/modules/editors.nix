# Editors configuration (nixvim, zed, opencode)
{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "material-icon-theme"
      "nix"
    ];
    extraPackages = with pkgs; [
      nixd
      nil
    ];
    userSettings = {
      telemetry = {
        metrics = false;
      };
      vim_mode = true;
    };
  };

}
