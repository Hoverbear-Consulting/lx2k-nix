{ fetchFromGitHub, edk2, utillinux, nasm, acpica-tools, dtc, lib }:
let
  edk2-platforms = fetchFromGitHub {
    owner = "SolidRun";
    repo = "edk2-platforms";
    rev = "9dcd525ae9ac678fa9c5eb1df0fde5f35e473485";
    sha256 = "dfq+oDAjgyeQbNdp6IKS0TYScaNR8AADR1eMMsDkroo=";
  };
  edk2-non-osi = fetchFromGitHub {
    owner = "SolidRun";
    repo = "edk2-non-osi";
    rev = "c4f571fe0da70cafc58b90342a766da854e71572";
    sha256 = "RziJg1Hp3yEhSNXFOUAx2dsUY7tbYvYjtrZavMcELWc=";
  };
in
edk2.mkDerivation "${edk2-platforms}/Platform/SolidRun/LX2160aCex7/LX2160aCex7.dsc" {
  name = "tianocore-honeycomb-lx2k";
  nativeBuildInputs = [ utillinux nasm acpica-tools dtc ];
  buildInputs = [ acpica-tools ];
  hardeningDisable = [ "format" "stackprotector" "pic" "fortify" ];
  preBuild = ''
    export PACKAGES_PATH=${edk2}:${edk2-platforms}:${edk2-non-osi}
  '';
}
