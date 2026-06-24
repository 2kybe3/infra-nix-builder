{
  lib,
  self,
  ...
}:
let
  keys = import "${self}/keys.nix";

  ssh_config = builtins.toFile "ssh.config" ''
    ${builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: ''
        Host ${value.hosts}
          IdentitiesOnly yes
          IdentityFile ~/.ssh/${name}
      '') keys
    )}
  '';
in
{
  sops.secrets = builtins.listToAttrs (
    map (name: {
      name = name;
      value = {
        sopsFile = "${self}/secrets/keys/${name}";
        path = "/home/ci/.ssh/${name}";
        format = "binary";
        mode = "0600";
        owner = "ci";
      };
    }) (builtins.attrNames keys)
  );

  systemd.tmpfiles.settings."ssh-ci-provision" = {
    "/home/ci/.ssh".d = {
      user = "ci";
      group = "wheel";
    };
    "/home/ci/.ssh/config"."L+" = {
      user = "ci";
      group = "wheel";
      argument = "${ssh_config}";
    };
  };
}
