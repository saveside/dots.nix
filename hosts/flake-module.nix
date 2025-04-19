{ inputs, ... }:

{
  flake.homeConfigurations = {
    savew-notebook-arch = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = {
        inherit inputs;
      };
      modules = [
        ./savew-notebook-arch/home
        (inputs.self + "/users/savew/home")
      ];
    };
  };

  flake.nixosConfigurations = {
    savew-notebook-nixos = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./savew-notebook-nixos
        inputs.home-manager.nixosModules.home-manager
      ];
    };
  };
}
