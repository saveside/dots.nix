# dots.nix

NixOS configuration with multi-host support and modular system/home separation.

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
│   └── <hostname>/              # Per-host system configuration
│       ├── default.nix          # Main entry, imports modules
│       ├── boot.nix             # Boot loader, kernel
│       ├── networking.nix       # Network, DNS, VPN
│       ├── users.nix            # User accounts
│       └── ...                  # Host-specific modules
├── home/
│   ├── <hostname>.nix           # Per-host home-manager config
│   ├── base.nix                 # Shared base (shell, CLI tools)
│   └── desktop/                 # Desktop modules (hyprland, etc.)
└── secrets/                     # Agenix encrypted secrets
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

## Adding a New Host

### 1. Create host directory

```bash
mkdir -p hosts/myhost
```

### 2. Create host files

**`hosts/myhost/default.nix`**
```nix
{ ... }:
{
  imports = [
    ./hardware.nix
    ./disk.nix
  ];

  networking.hostName = "savew-myhost";
  system.stateVersion = "25.11";
}
```

**`hosts/myhost/hardware.nix`**
```bash
nixos-generate-config --show-hardware-config > hosts/myhost/hardware.nix
```

**`hosts/myhost/vars.nix`**
```nix
# For desktop hosts
{ type }:
{
  monitors = [
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      refresh = 60;
      position = "0x0";
      scale = 1;
      disabled = false;
    }
  ];
}

# For server hosts (empty monitors)
{ type }:
{
  monitors = [];
}
```

### 3. Create system configuration

```bash
mkdir -p system/myhost
```

**`system/myhost/default.nix`**
```nix
{ ... }:
{
  imports = [
    ./boot.nix
    ./networking.nix
    ./users.nix
    # Add more modules as needed
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.zsh.enable = true;
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";
}
```

### 4. Create home configuration

**`home/myhost.nix`**
```nix
{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./base.nix
    ./editors.nix
    # Add desktop modules for GUI hosts:
    # ./desktop/hyprland
    # ./browsers.nix
    # ./media.nix
  ];

  programs.home-manager.enable = true;
}
```

### 5. Register host in flake.nix

```nix
flake.nixosConfigurations = {
  # ...existing hosts...

  myhost = mkHost {
    name = "myhost";
    type = "myhost";           # Matches system/myhost/ and home/myhost.nix
    system = "x86_64-linux";   # or "aarch64-linux"
  };
};
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

### Home Modules (shared)

- `base.nix` - Shell, git, CLI tools (all hosts)
- `editors.nix` - Neovim/nixvim configuration
- `desktop/hyprland/` - Hyprland window manager config
- `browsers.nix` - Browser configurations
- `media.nix` - Media applications
- `tools.nix` - Various utilities
