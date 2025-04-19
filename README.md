# save's dots (fork of xeome's dots)
![sway](https://raw.githubusercontent.com/saveside/dots/refs/heads/main/assets/Banner.png)

This dotfiles is made for personal use. I use it with Nix Package Manager, so you can use it with NixOS or Nix installed on your system.

## Configuration & Modules

| Name                   | Description                                                            |
| ---------------------- | ---------------------------------------------------------------------- |
| [Assets](./assets)     | Assets for the configuration (wallpapers, etc.)                        |
| [Hosts](./hosts)       | Configuration for hosts (laptop, desktop, etc.)                        |
| [Modules](./modules)   | Package configurations and nixGL wrapped packages                      |
| [Packages](./packages) | Modded & Custom packages                                               |
| [Users](./users)       | User configurations (home-manager)                                     |

## Hosts

| Name                                                 | Description                                                                     |
| ---------------------------------------------------- | ------------------------------------------------------------------------------- |
| [savew-notebook-arch](./hosts/savew-notebook-arch)   | Laptop running a Intel i7-13650HX, 16GB of RAM and GeForce RTX 4050 Mobile      |

## Installation (for home-manager only setups)

- First, set up some packages on your system. (I'm using Arch, so you can use this command to install them)

  ```bash
  yay -S git curl zsh gtklock polkit-gnome
  ```

  - We need to install gtklock using the distribution's own package manager. Because the home-manager is not compatible with pam-locking. If you use another distribution, you can install it with your package manager.

- Set up Nix Package Manager on your system (if you haven't already or you don't have NixOS installed)

    ```sh
    NIX_VERSION="unstable" #~ or latest stable version e.g "24.11"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    nix-channel --add https://nixos.org/channels/nixos-${NIX_VERSION} nixpkgs
    nix-channel --update
    ```

- Enable flake support in Nix

    ```sh
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
    ```

- Set up home-manager from [this](https://nix-community.github.io/home-manager/index.xhtml#ch-installation) source

  - For unstable nixpkgs:

    ```sh
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    ```

  - For stable nixpkgs:

    ```sh
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    ```

- Switch this flake

    ```sh
    home-manager switch --no-out-link --flake github:saveside/dots.nix/unstable#savew-notebook-arch
    ```

    Note: In this example, you must change username into the [hosts/savew-notebook-arch/home/default.nix](./hosts/savew-notebook-arch/home/default.nix) file.

## Screenshot

![sway](https://raw.githubusercontent.com/saveside/dots.nix/refs/heads/main/assets/banner.png)
## Credits & Big Thanks

- [xeome](https://github.com/xeome) - For the original inspiration and his dots! [dots](https://github.com/xeome/dots)
- [mt190502](https://github.com/mt190502) - I basically copy pasted and edited his [config](https://github.com/mt190502/dotfiles.nix)
