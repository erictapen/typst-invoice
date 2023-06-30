# SPDX-FileCopyrightText: 2023 Kerstin Humm <kerstin@erictapen.name>
#
# SPDX-License-Identifier: GPL-3.0-or-later

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

        checks = {
          reuse = pkgs.runCommand "reuse-check" { } ''
            ${pkgs.reuse}/bin/reuse --root ${self} lint && touch $out
          '';
          build = self.packages."${system}".default;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            typst
            reuse
          ];
        };

      });


}
