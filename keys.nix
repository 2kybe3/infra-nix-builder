{
  "nix_main" = {
    hosts = "nix-main.internal.kybe.xyz";
    _ = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOQl0E3yt31laA6LoeQcXoUCbmjDBi/qH6E/IlC/lMtF nix-builder -> nix-main";
  };
  "nix_builder" = {
    hosts = "nix-builder.internal.kybe.xyz";
    _ = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNzgml2ZFcWJzkRal3VwUNx0w23yUTqUNvWw4Q1m7FR nix-builder -> nix-builder";
  };
  "caddy_public_private" = {
    hosts = "caddy-public.internal.kybe.xyz caddy-internal.internal.kybe.xyz";
    _ = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAOf/P3GM9bQA8nbVfoMt5BvIILwLw/f379yNZGeMNey nix-builder -> caddy-public/private";
  };
  "rusherhack_plugin_compiler" = {
    hosts = "plugin-compiler.internal.kybe.xyz";
    _ = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP2JesMt+Cf+txjkDg1S2nUn96TZTMzZ1XX3iis9/42U nix-builder -> rusherhack-plugin-compiler";
  };
  "dns" = {
    hosts = "dns.internal.kybe.xyz";
    _ = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbfw5zMs8dCRna7GgWLsLoLxOfDVtZfivHeOl8daktH nix-builder -> dns";
  };
  "git" = {
    hosts = "gitc.kybe.xyz";
    _ = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIITiNhFmcoxstZ+EbptSnYVc57+6PBh0BqNHbbdACLeF nix-builder -> git.kybe.xyz (private)";
  };
}
