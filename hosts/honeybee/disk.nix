{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              device = "/dev/nvme0n1p2";
              size = "450G";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "subvol=home"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/nix/store" = {
                    mountpoint = "/nix/store";
                    mountOptions = [
                      "subvol=/nix/store"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
            plainSwap = {
                size = "100%";
                device = "/dev/nvme0n1p3";
                content = {
                        type = "swap";
                        discardPolicy = "both";
                        resumeDevice = true;
                };
           };
          };
        };
      };
    };
  };
}
