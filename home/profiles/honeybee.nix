# Honeybee home configuration - CLI tools only, no GUI
{ ... }:

{
  imports = [
    ../base.nix
    ../modules/editors.nix
  ];

  programs.home-manager.enable = true;
}
