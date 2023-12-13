inputs @ { lib, builtins, ... }: {
  alacritty = import ./alacritty;
  fzf = import ./fzf;
  git = import ./git;
  htop = import ./htop inputs;
  mpv = import ./mpv;
  ssh = import ./ssh;
  tmux = import ./tmux;
  zathura = import ./zathura;
  zsh = import ./zsh inputs;
}
