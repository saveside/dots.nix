# Vicinae app launcher configuration
{ ... }:

{
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    settings = {
      font = {
        size = 10;
        normal = "SF Pro Text";
      };
      popToRootOnClose = false;
      closeOnFocusLoss = false;
      considerPreedit = false;
      faviconService = "twenty";
      rootSearch = {
        searchFiles = false;
      };
      theme.name = "zinc";
      window = {
        csd = true;
        opacity = 0.9;
        rounding = 10;
      };
    };
  };
}
