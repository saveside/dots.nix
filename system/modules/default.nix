# Feature module registry — every module declares options.cfg.<x>.enable
# and does nothing until the host flips it on.
{ ... }:

{
  imports = [
    ./sway.nix
    ./hyprland.nix
    ./nvidia.nix
    ./virtualization.nix
    ./gaming.nix
    ./laptop.nix
    ./sound.nix
    ./scheduling.nix
  ];
}
