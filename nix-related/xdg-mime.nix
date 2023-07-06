{ config, ...} :

{

	environment.variables.XDG_CONFIG_DIRS = [ "/etc/xdg" ];
	environment.etc."xdg/mimeapps.list" = {
	  text = ''
[Default Applications]
inode/directory=pcmanfm-qt.desktop;
application/pdf=org.kde.okular.desktop;
video/mp4=mpv.desktop
text/plain=nvim.desktop
video/x-matroska=mpv.desktop
x-scheme-handler/https=firefox.desktop
x-scheme-handler/http=firefox.desktop
	  '';
	};

}

