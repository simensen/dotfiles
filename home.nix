{ ... }: {
  programs.home-manager.enable = true;

   programs.home-manager.enable = true;

   home.packages = [
    pkgs.cowsay
    pkgs.ponysay
  ];
}
