{
  description = "nix-builder";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    sops-nix,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    nixosConfigurations."nix-builder" = nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      specialArgs = {
        inherit self system;
      };

      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
      ];
    };
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
