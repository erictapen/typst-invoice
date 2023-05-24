{
  description = "Typst template for invoices";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {

        packages.default = pkgs.runCommand "typst-invoice" { } ''
          mkdir -p $out
          ${pkgs.typst}/bin/typst compile invoice.typ $out/invoice.pdf
        '';

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ typst ];
        };

      });


}
