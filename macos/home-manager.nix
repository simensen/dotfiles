{ config, pkgs, lib, ... }:

let
  common-programs = import ../common/home-manager.nix { config = config; pkgs = pkgs; lib = lib; };
  home-manager-real = import ../common/home-manager-real.nix { config = config; pkgs = pkgs; lib = lib; };
  mas-apps = import ./mas-apps.nix { };
  brews = import ./brews.nix { };
in
{
  imports = [
    <home-manager/nix-darwin>
    ./link-apps
  #  ./dock
];

  # local.dock.enable = true;
  # local.dock.entries = [
  #   { path = "/Applications/Slack.app/"; }
  #   { path = "/System/Applications/Messages.app/"; }
  #   { path = "/System/Applications/Facetime.app/"; }
  #   { path = "/Applications/Telegram.app/"; }
  #   { path = "/Applications/Notion.app/"; }
  #   { path = "/Applications/Brave Browser.app/"; }
  #   { path = "/Applications/Home Manager Apps/Alacritty.app/"; }
  #   { path = "/Applications/Discord.app/"; }
  #   { path = "/Applications/Home Manager Apps/Emacs.app/"; }
  #   { path = "/System/Applications/Podcasts.app/"; }
  #   { path = "/Applications/Spotify.app/"; }
  #   { path = "/Applications/Steam.app/"; }
  #   { path = "/System/Applications/News.app/"; }
  #   { path = "/System/Applications/Photos.app/"; }
  #   { path = "/System/Applications/Photo Booth.app/"; }
  #   { path = "/Applications/Drafts.app/"; }
  #   { path = "/System/Applications/Home.app/"; }
  #   {
  #     path = "/Users/dustin/State/";
  #     section = "others";
  #     options = "--sort name --view grid --display folder";
  #   }
  #   {
  #     path = "/Users/dustin/State/Inbox/Downloads";
  #     section = "others";
  #     options = "--sort name --view grid --display stack";
  #   }
  # ];

  # It me
  users.users.beausimensen = {
    name = "beausimensen";
    home = "/Users/beausimensen";
    isHidden = false;
    shell = pkgs.zsh;
  };

  # We use Homebrew to install impure software only (Mac Apps)
  homebrew.enable = true;
  homebrew.onActivation = {
	autoUpdate = true;
	cleanup = "zap";
	upgrade = true;
      };
  homebrew.brewPrefix = "/opt/homebrew/bin";
  homebrew.taps = [
    "homebrew/cask-fonts"
    #"mutagen-io/mutagen"
  ];
  #homebrew.brews = [
  #  "mutagen-io/mutagen/mutagen"
  #];
  homebrew.casks = pkgs.callPackage ./casks.nix {};
  homebrew.masApps = mas-apps;
  homebrew.brews = brews;

  home-manager = {
    useGlobalPkgs = true;
    users.beausimensen = { pkgs, lib, ... }: {
      home.enableNixpkgsReleaseCheck = false;
      home.packages = pkgs.callPackage ./packages.nix {};
      home.stateVersion = "23.05";

      programs = common-programs // {};
      home.file = home-manager-real // {};

      # https://github.com/nix-community/home-manager/issues/3344
      # Marked broken Oct 20th, check later to remove this
      manual.manpages.enable = false;

      editorconfig.enable = true;
    };
  };

  # Add home-manager applications to `system.build.applications` so they will be linked
  # by services.link-apps.
  system.build.applications = pkgs.lib.mkForce (pkgs.buildEnv {
    name = "applications";
    paths = config.environment.systemPackages ++ config.home-manager.users.beausimensen.home.packages;
    pathsToLink = "/Applications";
  });

  services.link-apps = {
    enable = true;
    userName = config.users.users.beausimensen.name;
    userHome = config.users.users.beausimensen.home;
  };
}
