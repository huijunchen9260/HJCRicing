# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

  # unstable = import
  #   (fetchTarball
  #     https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz) {};
in
{
    imports = [
	# Include the results of the hardware scan.
        ./hardware-configuration.nix
	./xdg-mime.nix
    ];

    # Use the systemd-boot EFI boot loader.
    boot = {
	loader.systemd-boot.enable = true;
	loader.efi.canTouchEfiVariables = true;
	blacklistedKernelModules = [
	    "nouveau"
	];
	kernelModules = [ "tp_smapi" ];
	extraModulePackages = with config.boot.kernelPackages; [ tp_smapi nvidia_x11 ];
	extraModprobeConfig = ''
	    options bbswitch load_state=-1 unload_state=1 nvidia-drm
	'';
    };


    hardware.nvidia = {
	prime = {
	    # offload.enable = true;
	    sync.enable = true;
	    nvidiaBusId = "PCI:1:0:0";
	    intelBusId = "PCI:0:2:0";
	};
	modesetting.enable = true;
	powerManagement.enable = true;
    };

    hardware.opengl.driSupport32Bit = true;

    # Set your time zone.
    time.timeZone = "America/New_York";


    networking = {
	hostName = "HJC"; # Define your hostname.
	networkmanager.enable = true; # Enables wireless support via NetworkManager
	wireless.enable = false; # explicitly disable wpa_supplicant
	useDHCP = false; # explicitly disable DHCP
	# Configure network proxy if necessary
	# proxy.default = "http://user:password@proxy:port/";
	# proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    };



    i18n = {
	# Select internationalisation properties.
	defaultLocale = "en_US.UTF-8";
	supportedLocales = [ "zh_TW.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" ];
	inputMethod = {
	    enabled = "fcitx";
	    fcitx.engines = with pkgs.fcitx-engines; [
		mozc
		chewing
	    ];
	};
    };

    console = {
	font = "Lat2-Terminus16";
	keyMap = "us";
    };
    services = {
	xserver = {
	    videoDrivers = [ "nvidia" ];
	    enable = true;
	    displayManager.lightdm.enable = true;
	    # displayManager.startx.enable = true;
	    # displayManager.defaultSession = "none+bspwm";
	    desktopManager = {
		lxqt.enable = true;
	    };
	    windowManager = {
		bspwm.enable = true;
		bspwm.configFile = "/home/huijunchen/.config/bspwm/bspwmrc";
		bspwm.sxhkd.configFile = "/home/huijunchen/.config/sxhkd/sxhkdrc";
	    };
	    # X11 kb layout
	    layout = "us";
	    # CUPS / touchpad
	    libinput.enable = true;
	};
	printing.enable = true;
	printing.drivers = [ pkgs.canon-cups-ufr2 pkgs.gutenprint ];

	# No sudo on backlight
	udev.extraRules = ''
	    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
	'';
	# Allow mlocate
	locate = {
	    enable = true;
	    locate = pkgs.mlocate;
	    interval = "hourly";
	};
	openssh.enable = true;
    };

    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.huijunchen = {
	isNormalUser = true;
	extraGroups = [
	    "wheel" 		 # Enable ‘sudo’ for the user.
	    "networkmanager"  # Allow user to access networkmanager
	    "audio"		 # PulseAudio
	    "mlocate"	 # mlocate
	    "vboxusers"	 # virtualbox
	    "adbusers"	# andriod debugging
	];
	shell = pkgs.zsh;
    };

    nixpkgs.config.allowUnfree = true; # allow unfree packages
    # allow insecure packages
    nixpkgs.config.permittedInsecurePackages = [
	"xpdf-4.02"
	"spidermonkey-38.8.0"
    ];
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
	# terminal
	termite
	alacritty
	rxvt-unicode
	urxvt_perl
	st
	xst

	# shell
	zsh
	dash

	# bspwm
	bspwm
	sxhkd
	wmname
	lemonbar-xft

	# CLI
	wget
	git
	bc
	neofetch
	biber
	pandoc
	ncdu
	shellcheck
	xclip
	xsel
	xcape
	xdo
	xdotool
	xorg.xmodmap
	xorg.xkill
	xorg.xwininfo
	xorg.xev
	xsettingsd
	xwallpaper
	wmctrl
	killall
	fzf
	htop
	xpdf # pdfinfo
	mlocate # locate & updatedb
	pciutils # lspci
	pstree
	pkgs.texlive.combined.scheme-full
	ntfs3g
	exfat-utils
	plan9port
	posix_man_pages
	libcap_manpages
	file
	jq
	pdf2svg
	poppler_utils
	djvulibre
	djvu2pdf
	asciinema
	imagemagick
	pdftk
	onefetch
	neofetch
	libheif
	tree
	axel
	groff
	lsb-release
	v4l-utils
	gnumake
	languagetool
	epstool
	ripgrep
	fd
	universal-ctags
	silver-searcher
	translate-shell
	qrencode
	megatools
	binutils
	ifuse
	usbutils
	unoconv
	nawk

	## remarkable
	remarkable-mouse
	rmapi

	## compression
	commonsCompress
	lz4
	zip
	unzip
	unrar
	p7zip

	# TUI
	visidata
	joplin
	neovim
	vim

	# language
	python
	python2
	R
	maxima
	nodejs
	go
	gcc
	gfortran
	jdk
	dbus

	# python packages
 	# python38Packages.pyqt5
	# python38Packages.paramiko
	# python38Packages.scp
	# python38Packages.twisted

	# GUI
	pcmanfm
	firefox
	chromium
	dmenu
	arandr
	notepadqq
	libreoffice
	simple-scan
	sxiv
	zathura
	zoom-us
	okular
	flameshot
	peek
	xournalpp
	inkscape
	simplenote
	adbfs-rootless
	steam
	texmacs
	wxmaxima
	lyx
	vmpk
	megasync

	# wine
	wineWowPackages.stable
	wineWowPackages.staging
	winetricks
	mesa-demos

	# Game
	zeroad

	# Video
	ffmpeg-full
	mpv

	# Torrent
	transmission
	transmission-qt

	# Music
	mpc_cli
	mpc-qt
	ncmpcpp
	mpd
	pulsemixer

	# fonts
	noto-fonts-cjk
	noto-fonts-emoji
	noto-fonts-extra
	libertine
	inconsolata
	ibm-plex
	font-awesome

	# lxqt related
	pkgs.libsForQt5.breeze-grub
	pkgs.libsForQt5.breeze-gtk
	pkgs.libsForQt5.breeze-icons
	pkgs.libsForQt5.breeze-plymouth
	pkgs.libsForQt5.breeze-qt5
	pkgs.matcha-gtk-theme
	pkgs.qtstyleplugin-kvantum-qt4
	pkgs.libsForQt5.qtstyleplugin-kvantum
	pkgs.libsForQt514.qtstyleplugin-kvantum
	pkgs.libsForQt512.qtstyleplugin-kvantum
	# pkgs.libsForQt5.networkmanager-qt
	# qt5ct
	# libstatgrab
	picom
	pkgs.papirus-maia-icon-theme
	nvidia-offload
    ];

    programs = {
	# Start SUID wrapper
	mtr.enable = true;
	gnupg.agent = {
	    enable = true;
	    enableSSHSupport = true;
	};

	# Enable zsh as default
	zsh.enable = true;
	zsh.syntaxHighlighting.enable = true;

	# Use nm-applet
	nm-applet.enable = true;

	# Use adb
	adb.enable = true;
    };


    # Force to load user profile
    environment.loginShellInit = ''
	. $HOME/.profile
	. $HOME/.xprofile
	xrandr --setprovideroutputsource NVIDIA-G0 modesetting
	xrandr --auto
    '';

    environment.sessionVariables = {
	XCURSOR_PATH = [
	    "${config.system.path}/share/icons"
		"$HOME/.icons"
		"$HOME/.nix-profile/share/icons/"
	];
    };



    # Fonts
    fonts = {
	enableDefaultFonts = true;
	fontconfig.enable = true;
	fontDir.enable = true;
	enableGhostscriptFonts = true;
	fonts = with pkgs; [
	    noto-fonts-cjk
	    noto-fonts-emoji
	    noto-fonts-extra
	    libertine
	    inconsolata
	    ibm-plex
	];
    };

    users.extraGroups.vboxusers.members = [ "huijunchen" ];
    virtualisation.virtualbox.host.enable = true;
    # virtualisation.virtualbox.host.headless = true;
    # virtualisation.virtualbox.host.package = true;
    # virtualisation.virtualbox.host.enableHardening = true;
    # virtualisation.virtualbox.host.addNetworkInterface = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;


    documentation = {
	enable = true;
	dev.enable = true;
	nixos.enable = true;
	nixos.includeAllModules = true;
	doc.enable = true;
	info.enable = true;
	man.enable = true;
	man.generateCaches = true;	# enable man -k
    };


    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "20.09"; # Did you read the comment?

}

