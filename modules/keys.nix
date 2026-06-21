{
  self,
  ...
}:
let
  keys = import "${self}/keys.nix";
  key_names = builtins.attrNames keys;

  ssh_config = ''
    Host *
      IdentitiesOnly yes
      ${builtins.concatStringsSep "\n" (map (name: "  IdentityFile ~/.ssh/${name}") key_names)}
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
    }) key_names
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
