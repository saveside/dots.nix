{
  pkgs,
  ...
}:

{
  home.file.".themes" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "ZorinOS";
      repo = "zorin-desktop-themes";
      rev = "d3243e4";
      sha256 = "sha256-eeEU+yYpfzzIiyGu5IbPPv4rEO5E8Waeh9wyGxcEmPw=";
    };
  };
  xdg.configFile."Kvantum/MonochromeSolid/MonochromeSolid.kvconfig" = {
    recursive = true;
    source = builtins.fetchurl {
      url = "https://gitlab.com/pwyde/monochrome-kde/-/raw/master/Kvantum/MonochromeSolid/MonochromeSolid.kvconfig";
      sha256 = "sha256:1zjjcw33f7l32x5gzp9f44vy2jm2wgnklj9hv5hy3j3rdnqfjyda";
    };
  };
  xdg.configFile."Kvantum/MonochromeSolid/MonochromeSolid.svg" = {
    recursive = true;
    source = builtins.fetchurl {
      url = "https://gitlab.com/pwyde/monochrome-kde/-/raw/master/Kvantum/MonochromeSolid/MonochromeSolid.svg";
      sha256 = "sha256:0x0c34c36vm21qf991zip9impjfi9bx57k5lwgv9gk31k97b9zv8";
    };
  };
}
