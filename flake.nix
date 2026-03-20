{
  description = "nix-builder";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
  };

  outputs = {
    self,
    nixpkgs,
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
      ];
    };
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
