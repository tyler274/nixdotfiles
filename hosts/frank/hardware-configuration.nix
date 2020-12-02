{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "bcache" ];
    initrd.kernelModules = [ "amdgpu" ];
    extraModulePackages = [];
    kernelModules = [
      "kvm-amd"
      "asix"  # REVIEW Remove me when 5.9 kernel is available
    ];
    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. This is not a good idea for mission critical or
      #      server/headless builds, but on my lonely home system I prioritize
      #      raw performance over security.  The gains are minor.
      "mitigations=off"
      # Limit ZFS cache to 8gb. Sure, this system has 64gb, but I don't want
      # this biting me when I'm running multiple VMs.
      #"zfs.zfs_arc_max=8589934592"
    ];
  };

  # CPU
  nix.maxJobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.amd.updateMicrocode = true;

  # Displays


  # Storage
  # networking.hostId = "FrankNixOS";  # required by zfs
  fileSystems."/" =
    { device = "/dev/sdb1";
      fsType = "bcachefs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/95BA-8098";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/10a840a5-568b-4a3a-bc68-fd4577dbb71d"; }
    ];

}
