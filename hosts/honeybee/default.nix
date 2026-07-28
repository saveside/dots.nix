{ ... }:

{
  imports = [
    ./disk.nix
    ./boot.nix
    ./networking.nix
    ./users.nix
    ./services.nix
  ];

  # honeybee is a headless server — no cfg.*.enable flags flipped.
  # Every feature module in ../../system/modules stays off by default.

  networking.hostName = "savew-honeybee";

  system.stateVersion = "25.11";
}
