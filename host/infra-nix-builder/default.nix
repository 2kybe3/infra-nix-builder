{
  self,
  ...
}:
{
  imports = [
    "${self}/modules/nix.nix"
    "${self}/modules/sops.nix"
    "${self}/modules/keys.nix"
    "${self}/modules/users.nix"
    "${self}/modules/attic.nix"
    "${self}/modules/openssh.nix"
    "${self}/modules/proxmox.nix"
    "${self}/modules/packages.nix"
  ];

  networking.nameservers = [
    "10.0.4.1"
  ];

  system.stateVersion = "25.05";
}
