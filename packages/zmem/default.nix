{
  pkgs,
  ...
}:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "zmem";
  version = "master";
  src = pkgs.fetchFromGitHub {
    owner = "xeome";
    repo = pname;
    rev = version;
    sha256 = "sha256-1oTDxgfEUuVCJ1PsLzeINFO4uI41SNp28pAiM12hdeU=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-21VU12HAzVN8wChu50NOmTiudHdfMRsfiCNSKA6bHsQ=";
  meta = {
    description = "Advanced linux memory monitoring";
    homepage = "https://github.com/xeome/zmem";
  };
}
