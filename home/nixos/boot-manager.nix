{ config, pkgs, lib, ... }:
{
    environment.etc = {
      "issue" = {
        text = "[?12l[?25h";
        mode = "0444";
      };
    };

    console = {
      earlySetup = false;
    };

    boot = {
      kernelParams = lib.mkBefore [
        "logo.nologo"
        "fbcon=nodefer"
        "bgrt_disable"
        "vt.global_cursor_default=0"
        "quiet"
        "systemd.show_status=false"
        "loglevel=3"
        "udev.log_level=3"
        "udev.log_priority=3"
        "rd.udev.log_level=3"
        "splash"
      ];

      consoleLogLevel = 3;

      initrd = {
        verbose = false;
        systemd.enable = true;
      };

      loader = {
        grub.extraConfig = ''
            GRUB_TIMEOUT_STYLE=hidden
            GRUB_HIDDEN_TIMEOUT_QUIET=true
          '';
        timeout = 0;

        grub = {
            enable = true;
            useOSProber = false;
            splashImage = null;

            efiSupport = true;
            device = "nodev";

            # efiInstallAsRemovable = true;
            # device = "nodev";
        };

        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
        };
      };
    };
}
