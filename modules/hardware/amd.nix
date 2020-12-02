{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.nvidia;
in {
  options.modules.hardware.amd = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.opengl.enable = true;
    hardware.opengl.extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
    ];
    hardware.opengl.driSupport = true;
    hardware.opengl.driSupport32Bit = true;

    services.xserver.videoDrivers = [ "amdgpu" ];


    # environment.systemPackages = with pkgs; [
      # Respect XDG conventions, damn it!
    #  (writeScriptBin "nvidia-settings" ''
    #    #!${stdenv.shell}
    #    mkdir -p "$XDG_CONFIG_HOME/nvidia"
    #    exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
    #  '')
    #];
  };
}
