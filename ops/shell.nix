let
  nixpkgs = import ../pkg/nixpkgs.nix;
  pkgs = import nixpkgs {};
in
pkgs.mkShell {
  buildInputs = with pkgs; [ nixops ];

  shellHook = let
    pwd = toString ./.;
  in ''
    export NIX_PATH="nixpkgs=${nixpkgs}:machine=${pwd}/webserver.nix"
    export NIXOPS_STATE="${pwd}/localstate.nixops"
  '';
}
