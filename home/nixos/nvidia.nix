{ lib, pkgs, config, ... }:
let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.stable;
in
{
  # Conf for proprietary packages
  nixpkgs.config = {
    nvidia.acceptLicense = true;
    allowUnfree = true;
  };

  # Nix cache for CUDA
  nix.settings = {
    substituters = [ "https://cuda-maintainers.cachix.org" ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  # Additional System Packages
  environment.systemPackages = with pkgs; [
    vulkan-tools

    glxinfo

    libva-utils
  ];

  # Xorg & Wayland Video Drivers
  services.xserver = {
    enable = true;

    videoDrivers = [ "nvidia" ];
  };

  # Boot Config & Parameters
  boot = {
    # Kernel params for better Wayland & Hyprland integration
    kernelParams = [
      # Enable mode setting for Wayland
      "nvidia-drm.modeset=1"

      # Improves resume after sleep
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"

      # Performance & Power optimizations
      "nvidia.NVreg_RegistryDWords=PowerMizerEnable=0x1;PerfLevelSrc=0x2222;PowerMixerLevel=0x3;PowerMizerDefault=0x3;PowerMizerDefaultAC=0x3"
    ];

    # Kernel Modules to be loaded on boot
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" ];

    # Blacklist nouveau to avoid conflicts
    blacklistedKernelModules = [ "nouveau" ];
  };

  # Environment variables for better compatibility
  environment.variables = {
    # Hardware video acceleration
    LIBVA_DRIVER_NAME = "nvidia";

    # Force Wayland
    XDG_SESSION_TYPE = "wayland";

    # Graphics backend for Wayland
    GDM_BACKEND = "nvidia-drm";

    # Use Nvidia driver for GLX
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Fix cursors on Wayland
    WLR_NO_HARDWARE_CURSORS = "1";

    # Wayland support for Electron apps
    NIXOS_OZONE_WL = "1";

    # Steam
    STEAM_FORCE_DESKTOPUI_SCALING = "1";

    # Enables G-Sync if applicable
    __GL_GSYNC_ALLOWED = "1";

    # Enables Variable Refresh Rate if applicable
    _GL_VRR_ALLOWED = "1";

    # Fixes some misc. issues with Hyprland
    WLR_DRM_NO_ATOMIC = "1";

    # Config for new Nvidia driver
    NVD_BACKEND = "direct";

    # Wayland support for Firefox
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Hardware & Nvidia configuration
  hardware = {
    cpu = {
        updateMicrocode = true;
    };

    nvidia = {
      open = true;
      nvidiaSettings = true;

      package = nvidiaDriverChannel;

      # Prevents screen tearing
      forceFullCompositionPipeline = true;

      modesetting.enable = true;

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      # Configuration for AMD iGPU paired with NVidia dGPU
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        sync.enable = false;

        amdgpuBusId = "PCI:5:0:0"; # AMD iGPU
        nvidiaBusId = "PCI:1:0:0"; # Nvidia dGPU
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;

      package = nvidiaDriverChannel;

      extraPackages = with pkgs; [
        rocmPackages.clr

        nvidia-vaapi-driver

        vaapiVdpau

        mesa

        egl-wayland

        vulkan-loader
        vulkan-validation-layers

        libva
        libglvnd       # OpenGL support
        libvdpau       # Video acceleration
        libvdpau-va-gl
      ];
    };
  };

  # Enable NVIDIA Persistence Daemon (useful for stability with high-performance GPUs)
  systemd.services.nvidia-persistenced = {
    enable = true;

    description = "NVIDIA Persistence Daemon";

    wantedBy = [ "multi-user.target" ];
  };
}
