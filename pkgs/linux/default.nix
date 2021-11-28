{ pkgs, lib, ... }:

pkgs.buildLinux {
  src = pkgs.fetchFromGitHub {
    owner = "SolidRun";
    repo = "linux-stable";
    rev = "0503edef26918141bd75b464d1e50a6d82cd569a";
    sha256 = "UwqJ9AVzXYppfW5OPvtuvG36+gWhZ3/lVL6pIQw+5po=";
  };
  version = "5.12.17";
  kernelPatches = [ ];
  structuredExtraConfig = with pkgs.lib.kernel; {
    CGROUP_FREEZER = yes;
  };
}
