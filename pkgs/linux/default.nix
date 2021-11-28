{ pkgs, lib, ... }:

pkgs.buildLinux {
  src = pkgs.fetchFromGitHub {
    owner = "SolidRun";
    repo = "linux-stable";
    rev = "50aac898777d5fa62130f5eca5546b637cb444e8";
    sha256 = "iZInARLnOAjuzPaWu9ZHziQSubUHCNv2I8ZEAGrJJqI=";
  };
  version = "5.15.0";
  kernelPatches = [ ];
  structuredExtraConfig = with pkgs.lib.kernel; {
    CGROUP_FREEZER = yes;
  };
}
