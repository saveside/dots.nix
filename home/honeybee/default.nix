# Honeybee home configuration - CLI tools only, no GUI
{ inputs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ../base.nix
    ../editors.nix
  ];

  programs.home-manager.enable = true;
}
