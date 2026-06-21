{
  pkgs,
  build-script,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      curl
      git
      gnupg
      jq
      rsync
      unzip
      vim
    ]
    ++ [
      build-script
    ];
}
