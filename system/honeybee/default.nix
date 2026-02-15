# Honeybee server system configuration
{
  imports = [
    ./boot.nix
    ./networking.nix
    ./services.nix
    ./users.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;

  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";
}
