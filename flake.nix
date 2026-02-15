{
  description = "Save's Honey Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "unixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "unixpkgs";
    };

    disko.url = "github:nix-community/disko/latest";

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen = {
      url = "github:/InioX/Matugen";
    };

    agenix.url = "github:ryantm/agenix";
    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    let
      mkPkgs =
        name: system:
        import inputs.${name} {
          inherit system;
          config.allowUnfree = true;
        };

      mkHost =
        {
          name,
          type ? "desktop",
          system ? "x86_64-linux",
        }:
        let
          vars = import ./hosts/${name}/vars.nix { inherit type; };
        in
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = mkPkgs "nixpkgs" system;
          specialArgs = {
            inherit inputs system vars;
            hostType = type;
            unixpkgs = mkPkgs "unixpkgs" system;
          };
          modules = [
            ./hosts/${name}
            ./system/${type}
            inputs.disko.nixosModules.disko
            inputs.agenix.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs vars;
                  hostType = type;
                };
                users.savew = {
                  imports = [ ./home/${type} ];
                  home = {
                    username = "savew";
                    homeDirectory = "/home/savew";
                    stateVersion = "25.11";
                  };
                };
              };
            }
          ];
        };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [ inputs.pre-commit-hooks.flakeModule ];

      flake.nixosConfigurations = {
        notebook = mkHost {
          name = "notebook";
          type = "notebook";
        };

        honeybee = mkHost {
          name = "honeybee";
          type = "honeybee";
        };
      };

      perSystem = {
        pre-commit.settings.hooks = {
          nixfmt-rfc-style.enable = true;
          nil.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
      };
    };
}
