# Services configuration for honeybee server
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    lm_sensors
    agenix-cli
  ];

  # SSH for remote management
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Performance tuning
  services.tuned = {
    enable = true;
    profiles = {
      honeybee = {
        main.include = "latency-performance";
      };
    };
  };
}
