with import (import ./nixpkgs.nix) {};
let
  bp = callPackage (fetchFromGitHub {
    owner = "serokell";
    repo = "nix-npm-buildpackage";
    rev = "d45296118cae672982f192451dd3e19fa6c2d068";
    hash = "sha256-J39FdMjECbWGSXVHmEdyGBD2aRYGhg9bWEPf1/ZR47k=";
  }) {};

  tailwind-forms = bp.buildNpmPackage rec {
    pname = "tailwindcss-forms";
    version = "0.5.3";

    src = fetchFromGitHub {
      owner = "illegalprime";
      repo = pname;
      rev = "4f0b72db2a41e0871105d0764e6b642b73af68d8";
      hash = "sha256-PrKx76hdImK8AZqLfMgsUX+zCmcvDpMlQtEh0W9Dj2E=";
    };

    npmDepsHash = "sha256-000qbI5D9oDKGhN5MVYCRoZ3XNzDUJcOJXB3Auamzes=";
  };
in
runCommand "node_modules" {} ''
  mkdir -p $out/@tailwindcss
  ln -s ${tailwind-forms} $out/@tailwindcss/forms
''
