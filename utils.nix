{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    rsync
    traceroute
    nixpkgs-review
    nixpkgs-fmt
    nix-update
  ];
}
