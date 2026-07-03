{ ... }:

{
  programs.librewolf = {
    enable = true;
    settings = {
      "sidebar.verticalTabs" = true;
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    };
  };
}
