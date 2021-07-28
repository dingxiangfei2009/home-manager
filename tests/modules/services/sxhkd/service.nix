{ config, pkgs, ... }:

{
  config = {
    xsession = {
      enable = true;
      windowManager.command = "";
    };

    services.sxhkd = {
      enable = true;
      package = pkgs.runCommandLocal "dummy-package" { } "mkdir $out" // {
        outPath = "@sxhkd@";
      };
      extraOptions = [ "-m 1" ];
    };

    nmt.script = ''
      xsessionFile=home-files/.xsession

      assertFileExists $xsessionFile

      assertFileContains $xsessionFile \
        'systemctl --user stop sxhkd.scope 2> /dev/null || true'

      assertFileContains $xsessionFile \
        'systemd-cat -t sxhkd systemd-run --user --scope -u sxhkd @sxhkd@/bin/sxhkd -m 1 &'
    '';
  };
}