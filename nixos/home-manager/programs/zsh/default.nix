inputs @ { config, lib, ... }:
let
  zshenv = builtins.readFile ./zshenv.sh;
in
{
  enable = true;

  enableVteIntegration = true;

  dotDir = ".config/zsh";

  autocd = true;

  defaultKeymap = "viins";

  history = {
    ignoreDups = false;

    extended = true;

    save = 1000000;

    # TODO: error, does not exist
    # keep = 1000000;

    share = true;

    path = "${config.xdg.dataHome}/zsh/zsh_history"; # TODO: how to access config.xdg?
  };

  # TODO: error: The option `home-manager.users.u.programs.zsh.syntaxHighlighting' does not exist. Definition values:
  # syntaxHighlighting = {
  #   enable = true;
  # };

  initExtra = zshenv;

  # hack to also source zshenv in non-interactive shells
  envExtra = ''
    if [[ "$-" == *i* ]]; then
      return 0
    fi
    ${zshenv}
  '';
}