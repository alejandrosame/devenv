{ ... }:

{
  services.jupyenv.enable = true;

  enterShell = ''
    unset LD_LIBRARY_PATH # Temporary fix, see https://github.com/cachix/devenv/issues/555#issuecomment-1528748461
  '';
}
