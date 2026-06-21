{
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINkGo/tRIL/LXbY5kNDK4v8csBm2FRq9A1VhT0iK+cYu git.kybe.xyz (rusherhack-plugin-compiler) -> nix-builder"
      ];
    };
  };
  security.sudo.wheelNeedsPassword = false;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7irWuDZwx7ZvPSiUwBbxUxKL/7aMQmy/8oxput1bID kybe@knx"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNzgml2ZFcWJzkRal3VwUNx0w23yUTqUNvWw4Q1m7FR nix-builder -> nix-builder"
  ];
}
