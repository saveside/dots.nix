# Host-specific variables for notebook
{ type, ... }:

{
  inherit type;

  # Monitor configuration
  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1200;
      refresh = 165;
      position = "1920x0";
      scale = 1;
      disabled = true;
    }
  ];
}
