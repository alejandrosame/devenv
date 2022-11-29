{ pkgs
, lib
, config
, inputs
, ...
}:
let
  inherit (inputs) jupyterWith;
  cfg = config.jupyterWith;
  types = lib.types;
in
{
  options.jupyterWith = {
    enable = lib.mkEnableOption ''
      Add Jupyterlab process and kernels via JupyterWith.
    '';

    package =
      let
        inherit (jupyterWith.packages.${pkgs.system}) jupyterlab jupyterlab-all-example-kernels;
        inherit (jupyterWith.lib.${pkgs.system}) mkJupyterlab;
        jl = mkJupyterlab { };
      in
      lib.mkOption {
        type = types.package;
        description = "Which jupyterlab to use";
        default = jl;
        defaultText = "jupyterlab";
      };
  };

  config = lib.mkIf cfg.enable {
    packages =
      [
        cfg.package
      ]
      ++ (with pkgs; [
        nodejs
        nodePackages.npm
      ]);

    env.JUPYTER_CONFIG_DIR = "./";

    processes.jupyterlab = {
      exec = "${cfg.package}/bin/jupyter-lab";
    };
  };
}
