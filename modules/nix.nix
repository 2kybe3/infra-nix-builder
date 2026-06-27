{
  nix = {
    enable = true;
    channel.enable = false;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "pipe-operators"
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://attic.kybe.xyz/main" ];
      trusted-public-keys = [ "main:cb7V485kGP0lG7LtQ/suOgKOgtVxNXrnD6i5yCtnaMQ=" ];
      trusted-substituters = [ "https://attic.kybe.xyz/main" ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      use-xdg-base-directories = true;
    };
  };
}
