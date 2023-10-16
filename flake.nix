{
  description = "A flake for mp++";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    packages = forEachSupportedSystem ({pkgs}: {
      default = pkgs.stdenv.mkDerivation rec {
        pname = "mppp";
        version = "0.26"; # Replace with the actual version you intend to package.

        src = pkgs.fetchFromGitHub {
          owner = "bluescarni"; # Replace with the correct owner's name.
          repo = pname;
          rev = "v${version}";
          sha256 = "sha256-GMN19+Qg6d4cYnu6Vj268zHTmK9FV1/D9F+VyIpkm2s="; # Replace with the actual hash.
        };

        nativeBuildInputs = [pkgs.cmake];

        buildInputs = with pkgs; [
          boost
          gcc
          gnum4
          gmp.dev
          mpfr.dev
          gcc_debug.out
          libmpc

          stdenv.cc.cc.lib
        ];
        cmakeFlags = [
          "-DMPPP_WITH_QUADMATH=y"
          "-DMPPP_WITH_MPFR=y"
          "-DMPPP_WITH_MPC=y"
        ];

        # Specify CMake as the build method:
        configurePhase = ''
          mkdir -p build
          cd build
          cmake ..  -DCMAKE_INSTALL_PREFIX=$out -DMPPP_WITH_QUADMATH=y -DMPPP_WITH_MPFR=y -DMPPP_WITH_MPC=y
        '';

        buildPhase = ''
          make
        '';

        installPhase = ''
          make install
        '';
      };
    });
  };
}
