{ pkgs, ... }:

pkgs.buildLinux {
  src = pkgs.fetchFromGitHub {
    owner = "SolidRun";
    repo = "linux-stable";
    rev = "4c71505dce5df9254daacb96c7a869741289a461";
    sha256 = "1mqv6xvijrafkjf03bwjvfrcvd4h4576zbv8jpipfjzcxg6894zf";
  };
  version = "5.10.23";
  kernelPatches = [ ];
  structuredExtraConfig = with pkgs.lib.kernel; {
    CGROUP_FREEZER = yes;
  };
}
