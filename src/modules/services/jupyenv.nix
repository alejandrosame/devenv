{ pkgs
, lib
, config
, inputs
, ...
}:
let
  cfg = config.services.jupyenv;
  types = lib.types;
  setup = ''
    inputs:
      jupyenv:
        url: github:tweag/jupyenv
        inputs:
          nixpkgs:
            follows: nixpkgs
  '';
  jupyenvInput = inputs.jupyenv or (throw "To manage Jupyterlab using jupyenv, you need to add the following to your devenv.yaml:\n\n${setup}");
  inherit (jupyenvInput.packages.${pkgs.system}) jupyterlab jupyterlab-new jupyterlab-all-example-kernels;
  inherit (jupyenvInput.lib.${pkgs.system}) mkJupyterlab;
in
{
  options.services.jupyenv = {
    enable = lib.mkEnableOption ''
      Add Jupyterlab process and kernels via jupyenv.
    '';

    package = lib.mkOption {
      type = types.package;
      description = "Which jupyterlab to use";
      default = jupyterlab-new;
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
