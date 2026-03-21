{
  self,
  pkgs,
  ...
}: let
  keys = [
    "nix_main"
    "nix_builder"
    "caddy_public_private"
  ];
in {
  imports = [
    ./proxmox.nix
    ./utils.nix
    ./sops.nix
  ];

  sops.secrets = builtins.listToAttrs (map (name: {
      name = name;
      value = {
        sopsFile = "${self}/secrets/${name}";
        path = "/home/ci/.ssh/${name}";
        format = "binary";
        owner = "ci";
      };
    })
    keys);

  environment.systemPackages = with pkgs; [
    gnupg
    unzip
    git
    curl
    vim
    jq

    (pkgs.writeShellScriptBin "build" ''
      #!${pkgs.bash}/bin/bash
      ${builtins.readFile ./build.sh}
    '')
  ];

  systemd.tmpfiles.rules = [
    "d /home/ci/.ssh - ci wheel - -"
    "L+ /home/ci/.ssh/config - ci wheel - ${./ssh.config}"
  ];
  nix.settings.max-jobs = 6;
  users.users.ci = {
    isNormalUser = true;
    extraGroups = ["wheel"];

    openssh.authorizedKeys = {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7irWuDZwx7ZvPSiUwBbxUxKL/7aMQmy/8oxput1bID kybe@knx"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDeptJ/WeiQ3wuCpkHYAfSdH5h5l6kbJFSkiM/g7pZjZ git.kybe.xyz (infra-caddy) -> nix-builder"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzHEdANrzJkiRCD+WdoGhJieehwxuuXevLaNUPp83Ki git.kybe.xyz (infra-nix-main) -> nix-builder"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIODsU2Eyfj0bdNumTw9HW6yDukyNxNdc5q7JK7ONLeMm git.kybe.xyz (infra-nix-builder) -> nix-builder"
      ];
    };
  };
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7irWuDZwx7ZvPSiUwBbxUxKL/7aMQmy/8oxput1bID kybe@knx"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNzgml2ZFcWJzkRal3VwUNx0w23yUTqUNvWw4Q1m7FR nix-builder -> nix-builder"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.nameservers = [
    "10.0.4.1"
  ];

  system.stateVersion = "25.05";
}
