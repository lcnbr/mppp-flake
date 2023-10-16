{
  description = "A flake for mp++";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: 
  
  flake-utils.lib.eachDefaultSystem (system:  
  let 
    pkgs = nixpkgs.legacyPackages.${system};
    in {
    packages.${system}.mppp = with nixpkgs.legacyPackages.${system};
      stdenv.mkDerivation rec {
        pname = "mppp";
        version = "0.26"; # Replace with the actual version you intend to package.

        src = fetchFromGitHub {
          owner = "bluescarni"; # Replace with the correct owner's name.
          repo = pname;
          rev = "v${version}";
          sha256 = "sha256-GMN19+Qg6d4cYnu6Vj268zHTmK9FV1/D9F+VyIpkm2s="; # Replace with the actual hash.
        };

        nativeBuildInputs = [cmake];

        buildInputs = [
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
          cmake ..  -DCMAKE_INSTALL_PREFIX=$out
        '';

        buildPhase = ''
          make
        '';

        installPhase = ''
          make install
        '';

        meta = with lib; {
          description = "A high-performance arbitrary-precision arithmetic library for C++";
          license = licenses.mit; # Adjust according to the project's license.
          maintainers = with maintainers; ["your_name"]; # Add your maintainer name.
          homepage = "https://github.com/owner_name/mp++";
        };
      };

    defaultPackage.${system} = self.packages.${system}.mppp;
  };
}
