{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      treefmt,
      nixpkgs,
      sops-nix,
      flake-utils,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations."nix-builder" = nixpkgs.lib.nixosSystem {
        inherit pkgs;

        specialArgs = self.packages.${system} // {
          inherit self system;
        };

        modules = [
          ./host/infra-nix-builder
          sops-nix.nixosModules.sops
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        treefmt-eval = treefmt.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        packages.build-script = pkgs.callPackage ./assets/build-script { };
        checks.formatting = treefmt-eval.config.build.check self;
        formatter = treefmt-eval.config.build.wrapper;
      }
    );
}
