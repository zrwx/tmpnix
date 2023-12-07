{ disks, ... }: {
  disko.devices.disk.main = {
    type = "disk";
    device = builtins.elemAt disks 0;
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "luks";
            settings.allowDiscards = true;
            passwordFile = "/tmp/secret.txt";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };
  };

  disko.devices.zpool.zroot = {
    type = "zpool";
    postCreateHook = "zfs snapshot zroot/yeet@yeeted";
    datasets = {
      "yeet" = {
        type = "zfs_fs";
      };
      "keep" = {
        type = "zfs_fs";
        mountpoint = "/zfs_fs";
      };
      "nix" = {
        type = "zfs_fs";
        mountpoint = "/zfs_fs";
      };
    };
  };
}
