{
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "pipe-operators"
      "nix-command"
      "flakes"
    ];
    max-jobs = 32;
    substituters = [ "https://attic.kybe.xyz/main" ];
    trusted-public-keys = [ "main:cb7V485kGP0lG7LtQ/suOgKOgtVxNXrnD6i5yCtnaMQ=" ];
    trusted-substituters = [ "https://attic.kybe.xyz/main" ];
    trusted-users = [
      "root"
      "@wheel"
    ];
    use-xdg-base-directories = true;
  };
}
