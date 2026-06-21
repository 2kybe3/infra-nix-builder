{
  pkgs ? import <nixpgkgs> { },

}:
pkgs.writeShellApplication {
  name = "build";

  derivationArgs = {
    strictDeps = true;
    __structuredAttrs = true;
  };

  runtimeInputs = with pkgs; [
    coreutils
    git
    jq
  ];

  text = builtins.readFile ./script.sh;
}
