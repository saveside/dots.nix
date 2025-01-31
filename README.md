![sway](https://raw.githubusercontent.com/saveside/dots/refs/heads/main/assets/Banner.png)

This is my personal dotfiles made with Nix

## Installation

- First, set up some packages on your system (I'm using Arch, so you can use this command to install them)

    ```sh
    yay -S git curl gtklock
    ```

  - We need to install gtklock using the distribution's own package manager. Because the home-manager is not compatible with pam-locking. If you use another distribution, you can install it with your package manager.

- Set up Nix Package Manager on your system (if you haven't already or you don't have NixOS installed)

    ```sh
    NIX_VERSION="24.11"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    sudo -i nix-channel --add https://nixos.org/channels/nixos-${NIX_VERSION} nixpkgs
    nix-channel --add https://nixos.org/channels/nixos-${NIX_VERSION} nixpkgs
    nix-channel --update
    ```

- Enable flake support in Nix

    ```sh
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
    ```

- Set up home-manager from [this](https://nix-community.github.io/home-manager/index.xhtml#ch-installation) source

- Clone this repository

    ```sh
    git clone https://github.com/saveside/dots.nix
    cd dots.nix
    ```

- Switch this flake

    ```sh
    home-manager switch --no-out-link --flake .#savew-notebook
    ```

- Enjoy!

## Screenshot

![image](https://github.com/user-attachments/assets/f0db8ac3-9158-4e94-b108-922d96989d1a)

## References - Big Thanks :)

- mt190502 - <https://github.com/mt190502/dotfiles.nix> # Helped setup Nix Environment
- xeome - <https://github.com/xeome/dots> # Original Dotfiles Resource
