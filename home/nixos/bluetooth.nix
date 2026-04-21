{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ blueman ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.enableRedistributableFirmware = true;

  services.blueman.enable = true;
}
