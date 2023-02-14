{ pkgs }:

with pkgs; [
  colima
  coreutils
  curl
  docker
  docker-compose
  glow # CLI markdown viewer
  home-manager
  yq
  killall
  lima
  #mutagen
  mutagen-beau
  nebula
  nodePackages.npm
  nodejs
  powerline-fonts
  sqlite
  tree
  unrar
  unzip
  wget
  zip
  zsh-git-prompt
]
