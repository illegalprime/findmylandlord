{ config, lib, pkgs, ...}:
with lib;
let
  findmylandlord = import ./.;
  cfg = config.services.findmylandlord;
in
{
  options.services.findmylandlord = {
    port = mkOption { type = types.int; default = 8989; };
    useSSL = mkOption { type = types.bool; default = true; };
    forceSSL = mkOption { type = types.bool; default = true; };
    virtualhost = mkOption { type = types.str; };
  };

  config = {
    services.nginx.virtualHosts."${cfg.virtualhost}" = {
      enableACME = cfg.useSSL;
      forceSSL = cfg.useSSL && cfg.forceSSL;
      locations."/" = {
        proxyPass = "http://localhost:${toString cfg.port}/";
        proxyWebsockets = true;
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "findmylandlord" ];
      ensureUsers = [{
        name = "findmylandlord";
        ensurePermissions = {
          "DATABASE findmylandlord" = "ALL PRIVILEGES";
        };
      }];
    };

    systemd.services.findmylandlord = let
      passwd_set = "ALTER USER findmylandlord PASSWORD 'findmylandlord';";
    in {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        EnvironmentFile = ["/run/keys/findmylandlord"];
        Environment = [
          "PORT=${toString cfg.port}"
          "PHX_HOST=${cfg.virtualhost}"
          "DATABASE_URL=ecto://findmylandlord:findmylandlord@localhost/findmylandlord"
        ];
        User = "findmylandlord";
        Group = "findmylandlord";
        ExecStartPre = pkgs.writeShellScript "findmylandlord-pre" ''
          set -x
          ${pkgs.postgresql}/bin/psql -c "${passwd_set}"
          ${findmylandlord}/bin/migrate
        '';
        ExecStart = "${findmylandlord}/bin/server";
      };
    };

    users.users.findmylandlord = {
      isSystemUser = true;
      createHome = true;
      group = "findmylandlord";
    };
    users.groups.findmylandlord = { };
  };
}
