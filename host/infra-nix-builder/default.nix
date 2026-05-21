{
  self,
  pkgs,
  ...
}:
let
  keys = [
    "nix_main"
    "nix_builder"
    "caddy_public_private"
  ];

  build-script = pkgs.writeShellApplication {
    name = "build";

    runtimeInputs = with pkgs; [
      git
      jq
    ];

    text = builtins.readFile "${self}/assets/build.sh";
  };
in
{
  imports = [
    "${self}/modules/sops.nix"
    "${self}/modules/utils.nix"
    "${self}/modules/attic.nix"
    "${self}/modules/proxmox.nix"
  ];

  sops.secrets = builtins.listToAttrs (
    map (name: {
      name = name;
      value = {
        sopsFile = "${self}/secrets/${name}";
        path = "/home/ci/.ssh/${name}";
        format = "binary";
        owner = "ci";
      };
    }) keys
  );

  environment.systemPackages = with pkgs; [
    jq
    git
    vim
    curl
    unzip
    gnupg

    build-script
  ];

  systemd.tmpfiles.rules = [
    "d /home/ci/.ssh - ci wheel - -"
    "L+ /home/ci/.ssh/config - ci wheel - ${"${self}/assets/ssh.config"}"
  ];

  nix.settings = {
    max-jobs = 32;
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  users.users.ci = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys = {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7irWuDZwx7ZvPSiUwBbxUxKL/7aMQmy/8oxput1bID kybe@knx"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIErsJeX2oAU856/1zRtN1OsMCDRaipUeqaV8vRqSNi6H git.kybe.xyz -> nix-builder"
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
