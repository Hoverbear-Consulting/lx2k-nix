{ stdenv
, lib
, buildPackages
, fetchFromGitHub
, python3
, gettext
, ddrSpeed
}:

assert lib.elem ddrSpeed [ 2400 2600 2900 3200 ];
let
  memSpeed = lib.substring 0 2 (toString ddrSpeed);
in
stdenv.mkDerivation rec {
  pname = "rcw-mem-${toString ddrSpeed}MHz";
  version = "LSDK-20.04-sr";

  src = fetchFromGitHub {
    owner = "SolidRun";
    repo = "rcw";
    rev = "bf3f2f45f22fdd76252ce8326cc3413b473d55c4";
    sha256 = "YTmYGADxiSW0pYaoqwOAjm77GaBR2VlpTMdChOvwJvQ=";
  };

  nativeBuildInputs = [ python3 gettext ];

  postPatch = ''
    sed -i 's@gcc@${buildPackages.stdenv.cc}/bin/gcc@' Makefile.inc rcw.py
  '';

  preBuild = ''
    cd lx2160acex7
    (
    export SP1=8 SP2=5 SP3=2 SRC1=1 SCL1=2 SPD1=1 CPU=22 SYS=14 MEM=${memSpeed}
    envsubst < configs/lx2160a_serdes.def > configs/lx2160a_serdes.rcwi
    envsubst < configs/lx2160a_timings.def > configs/lx2160a_timings.rcwi
    )
  '';

  installPhase = ''
    mkdir -p $out/lx2160acex7
    cp -r rcws $out/lx2160acex7
  '';
}
