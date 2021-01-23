{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> {
    overlays = [
      (import ./overlay.nix)
      (self: super: {
        lx2k = super.lx2k.overrideScope' (self: super: {
          rcw = super.rcw.override { inherit ddrSpeed; };
        });
      })
    ];
    inherit system;
    ${if system == "aarch64-linux" then null else "crossSystem"} = "aarch64-linux";
  },
  ddrSpeed ? 3200
}:

{
  inherit (pkgs) linux_lx2k lx2k;

  sdImage = (pkgs.nixos ( { lib, ... }: {
    imports = [ (pkgs.path + /nixos/modules/installer/cd-dvd/sd-image-aarch64.nix) ];

    # use vendor kernel
    boot.kernelPackages = pkgs.linuxPackages_lx2k;

    # disable anything we don't need, like zfs
    boot.initrd.supportedFilesystems = lib.mkForce [ "ext4" ];
    boot.supportedFilesystems = lib.mkForce [ "ext4" ];

    # take from upstream
    boot.kernelParams = lib.mkForce [ "console=ttyAMA0,115200" "earlycon=pl011,mmio32,0x21c0000" "default_hugepagesz=1024m" "hugepagesz=1024m" "hugepages=2" "pci=pcie_bus_perf" ];
  })).config.system.build.sdImage;
}
