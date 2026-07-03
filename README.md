# dots.nix

A personal NixOS dotfiles.

## Structure

```
dots.nix/
├── flake.nix                    # Main flake with mkHost helper
├── hosts/
│   └── <hostname>/
│       ├── default.nix          # Host entry point
│       ├── hardware.nix         # Hardware configuration
│       ├── disk.nix             # Disko partition layout
│       └── vars.nix             # Host variables (monitors, etc.)
├── system/
│   └── <type>/                  # Shared system config by host type
│       ├── default.nix          # Main entry, imports modules
│       ├── boot.nix             # Boot loader, kernel
│       ├── networking.nix       # Network, DNS, VPN
│       ├── users.nix            # User accounts
│       └── ...                  # Type-specific modules
├── home/
│   ├── base.nix                 # Shared base (shell, CLI tools)
│   ├── modules/
│   │   ├── shell.nix            # Zsh, starship, aliases
│   │   ├── editors.nix          # Zed, nixvim
│   │   ├── browsers.nix         # Chromium
│   │   ├── media.nix            # MPD, ncmpcpp, mpv, yt-dlp
│   │   ├── kubernetes.nix       # kubectl, k9s, krew
│   │   ├── opencode.nix         # opencode AI config
│   │   ├── desktop/
│   │   │   ├── hyprland/        # Hyprland WM (settings, keybinds, etc.)
│   │   │   └── sway/            # Sway WM (settings, colors, keybinds, startup)
│   │   ├── apps/                # Application configs
│   │   │   ├── alacritty.nix
│   │   │   ├── librewolf.nix
│   │   │   ├── zathura.nix
│   │   │   └── vicinae.nix
│   │   └── tools/               # htop, mangohud, etc.
│   ├── profiles/
│   │   ├── notebook.nix         # Notebook profile (Hyprland + sway + apps)
│   │   └── honeybee.nix         # Server profile (CLI only)
│   └── scripts/                 # Utility scripts
├── secrets/                     # Agenix encrypted secrets
└── flake.lock
```

## Current Hosts

| Host | Type | Description |
|------|------|-------------|
| `notebook` | Desktop | Laptop with Hyprland, NVIDIA, full GUI |
| `honeybee` | Server | Headless server, SSH, minimal CLI |

## Usage

```bash
# Rebuild notebook
sudo nixos-rebuild switch --flake .#notebook

# Rebuild honeybee
sudo nixos-rebuild switch --flake .#honeybee
```

## mkHost Options

| Option | Default | Description |
|--------|---------|-------------|
| `name` | required | Host directory name under `hosts/` |
| `type` | `"desktop"` | Determines which `system/<type>/` and `home/<type>.nix` to use |
| `system` | `"x86_64-linux"` | Architecture (`x86_64-linux` or `aarch64-linux`) |

## Using vars in modules

Access host variables via `vars`:

```nix
{ vars, ... }:
{
  # vars.monitors available here
  # Example: configure Hyprland monitors from vars
}
```

## Module Organization

### System Modules (per-host)

- `boot.nix` - Boot loader, kernel, kernel params
- `networking.nix` - NetworkManager, DNS, Tailscale, firewall
- `sound.nix` - PipeWire audio (desktop only)
- `nvidia.nix` - NVIDIA GPU support (desktop only)
- `hyprland.nix` - Hyprland, display manager, XDG portals (desktop only)
- `virtualization.nix` - Docker, libvirtd (desktop only)
- `scheduling.nix` - SCX scheduler, performance tuning (desktop only)
- `services.nix` - SSH, system services (server only)
- `users.nix` - User accounts and groups

### Home Modules (under `home/modules/`)

- `shell.nix` - Zsh, starship, aliases
- `editors.nix` - Zed editor configuration
- `browsers.nix` - Chromium configuration
- `media.nix` - MPD, ncmpcpp, rmpc, mpv, yt-dlp
- `kubernetes.nix` - kubectl, k9s, krew, kubecolor
- `opencode.nix` - opencode AI assistant configuration
- `desktop/hyprland/` - Hyprland WM (settings, keybinds, colors, rules, startup, idle, lock)
- `desktop/sway/` - Sway WM (settings, colors, keybinds, startup) + waybar, swaync
- `apps/` - Application configs (alacritty, librewolf, zathura, vicinae/rofi)
- `tools/` - htop, mangohud

### Profiles (under `home/profiles/`)

- `notebook.nix` - Full desktop profile: Hyprland + sway, all apps, kubernetes, media, etc.
- `honeybee.nix` - Headless server profile: base + editors only
