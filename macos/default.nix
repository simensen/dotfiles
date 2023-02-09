{ config, pkgs, nixpkgs, buildGoModule, fetchzip, fetchFromGitHub, ... }:
{

  imports = [
    ../common
    ./cachix
    ./home-manager.nix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nixUnstable;
    settings.trusted-users = [ "@admin" "beausimensen" ];
    gc.user = "root";

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  environment.systemPackages = with pkgs; [
  ] ++ (import ../common/packages.nix { pkgs = pkgs; });

  # Enable fonts dir
  fonts.fontDir.enable = true;

  programs = { };

  system = {
    stateVersion = 4;

    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        AppleKeyboardUIMode = 3;

        #NSToolbarTitleViewRolloverDelay = 0.0;

        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;

        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;

        NSDocumentSaveNewDocumentsToCloud = false;

        NSDisableAutomaticTermination = true;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        #AppleLanguages = [ "en" ];
        #AppleLocale = "en_US@currency=USD";
        #AppleMeasurementUnits = "Inches";
        #AppleMetricUnits = false;

        #AppleFontSmoothing = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 6;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 25;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;

        #"com.apple.screencapture.type" = "png";
      };

      dock = {
        autohide = true;
        autohide-delay = 60.0;
        autohide-time-modifier = 0.0;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
