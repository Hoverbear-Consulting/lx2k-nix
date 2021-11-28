{ pkgs, lib, ... }:

pkgs.buildLinux {
  src = pkgs.fetchFromGitHub {
    owner = "SolidRun";
    repo = "linux-stable";
    rev = "4c71505dce5df9254daacb96c7a869741289a461";
    sha256 = "7pOEzOvsS3fjlWivb04hkLTNstuSrwGcnE5lGXc3G9c=";
  };
  version = "5.10.23";
  kernelPatches = [ ];
  structuredExtraConfig = with pkgs.lib.kernel; {
    CGROUP_FREEZER = yes;
  };
}
