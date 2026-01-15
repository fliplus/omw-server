{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };

            esp = {
              name = "ESP";
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          # https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS
          acltype = "posixacl";
          atime = "off";
          compression = "zstd";
          mountpoint = "none";
          xattr = "sa";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets = {
          "local" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };

          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options."com.sun:auto-snapshot" = "false";
          };

          "local/minecraft" = {
            type = "zfs_fs";
            mountpoint = "/srv/minecraft";
            options."com.sun:auto-snapshot" = "false";
          };
        };
      };
    };
  };

  services.zfs.autoScrub.enable = true;

  # https://github.com/openzfs/zfs/issues/10891
  systemd.services.systemd-udev-settle.enable = false;
}
