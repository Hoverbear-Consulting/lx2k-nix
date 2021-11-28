{ stdenv, lib, buildPackages, fetchFromGitHub, libuuid, python3, bc }:
let
  edk2 = stdenv.mkDerivation {
    pname = "edk2-solidrun";
    version = "edk2-stable202102-lx2160acex7";
    src = fetchFromGitHub {
      owner = "SolidRun";
      repo = "edk2";
      fetchSubmodules = true;
      rev = "f55a316f6f601d3e1f1aeaa2a98decfa0d4dab9d";
      sha256 = "MeCs8ZHJD7FWHnpXCj1vLwa4tzGp2BbdjrUBBg6qn7Y=";
    };

    depsBuildBuild = [ buildPackages.stdenv.cc ];
    nativeBuildInputs = [ libuuid python3 ];

    postPatch = "patchShebangs BaseTools/BinWrappers";

    makeFlags = [ "-C BaseTools" ]
      ++ lib.optional (stdenv.cc.isClang) [ "BUILD_CC=clang BUILD_CXX=clang++ BUILD_AS=clang" ];

    NIX_CFLAGS_COMPILE = "-Wno-return-type" + lib.optionalString (stdenv.cc.isGNU) " -Wno-error=stringop-truncation";

    hardeningDisable = [ "format" "fortify" ];

    installPhase = ''
      mkdir -vp $out
      mv -v BaseTools $out
      mv -v edksetup.sh $out
    '';

    enableParallelBuilding = true;

    passthru = {
      mkDerivation = projectDscPath: attrs: stdenv.mkDerivation ({
        inherit (edk2) src;

        nativeBuildInputs = [ bc python3 ] ++ attrs.nativeBuildInputs or [ ];

        prePatch = ''
          rm -rf BaseTools
          ln -sv ${edk2}/BaseTools BaseTools
        '';

        configurePhase = let
          crossPrefix =
            if stdenv.hostPlatform != stdenv.buildPlatform then
              stdenv.cc.targetPrefix
            else
              "";
        in ''
          runHook preConfigure
          export WORKSPACE="$PWD"
          export GCC5_AARCH64_PREFIX=${crossPrefix} DTCPP_PREFIX=${crossPrefix}
          . ${edk2}/edksetup.sh BaseTools
          runHook postConfigure
        '';

        buildPhase = ''
          runHook preBuild
          build -a AARCH64 -b ${attrs.releaseType or "RELEASE"} -t GCC5 -p ${projectDscPath} -n $NIX_BUILD_CORES
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mv -v Build/*/* $out
          runHook postInstall
        '';
      } // removeAttrs attrs [ "nativeBuildInputs" ]);
    };
  };
in
edk2
