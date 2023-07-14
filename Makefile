## Require GNU make

# PATH = $(shell du -L "${HOME}/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$$//')
TOPDIR := $(shell pwd)
MKDIR := mkdir -p
LN := ln -vsf
LNDIR := ln -vsfn
RM := rm
RMDIR := rm -rf
RSYNC := rsync -urvP
PACMAN := sudo pacman --noconfirm --needed -S
NPM := sudo npm install
# AUR := sudo -u $$USER paru --needed --skipreview --sudoloop --noconfirm -S
AUR := yay --needed --sudoloop --noconfirm -S
DOTS := $(shell printf '%s\n' ${TOPDIR}/.* | sed 's/.*\///g')
CONFIG := $(shell printf '%s\n' ${TOPDIR}/.config/* | sed 's/.*\///g')
BIN := $(shell printf '%s\n' ${TOPDIR}/.local/bin/* | sed 's/.*\///g')
# CMD := $(shell printf '%s\n' ${TOPDIR}/.local/bin/hjcmds/* | sed 's/.*\///g')
# APP := $(shell printf '%s\n' ${TOPDIR}/.local/bin/hjapps/* | sed 's/.*\///g')
SRC := $(shell printf '%s\n' ${TOPDIR}/.local/src/* | sed 's/.*\///g')
SHARE := $(shell printf '%s\n' ${TOPDIR}/.local/share/* | sed 's/.*\///g')
ETC := $(shell printf '%s\n' ${TOPDIR}/etc/* | sed 's/.*\///g')
# NVIDIA = $(shell lspci | grep -i '.* vga .* nvidia .*')

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.ONESHELL:
dotusb: ## sync local dotfiles with usb
	lsblk -nrpo "name,type,size,mountpoint" | awk '$$2=="part" && $$4 !~ /\/boot|\/home$$|SWAP/ && length($$4)>1 {printf "%d. %s (%s)\n",++i,$$4,$$3}'
	@read -p "Choose which usb to sync: " usb
	lsblk -nrpo "name,type,size,mountpoint" | awk -v usb=$$usb '$$2=="part" && $$4 !~ /\/boot|\/home$$|SWAP/ && length($$4)>1 {if (++i == usb) {printf "%s", $$NF}}' | xargs -I {} $(RSYNC) --delete ${TOPDIR} {}

dotlocal: ## sync usb dotfiles with local
	$(PACMAN) rsync
	$(RSYNC) --delete ${TOPDIR} ${HOME}

.ONESHELL:
config: ## initialize ${HOME}/.config
	for item in $(CONFIG); do
	    $(MKDIR) ${HOME}/.config;
	    test -L ${HOME}/.config/$$item && continue || $(RMDIR) ${HOME}/.config/$$item;
	    $(LN) {${TOPDIR},${HOME}}/.config/$$item;
	done

x11:
	test -L ${HOME}/.xinitrc  && continue || $(RM) ${HOME}/.xinitrc;
	$(LN) ${TOPDIR}/.config/x11/xinitrc ${HOME}/.xinitrc;
	test -L ${HOME}/.xprofile  && continue || $(RM) ${HOME}/.xprofile;
	$(LN) ${TOPDIR}/.config/x11/xprofile ${HOME}/.xprofile;
	test -L ${HOME}/.Xresources  && continue || $(RM) ${HOME}/.Xresources;
	$(LN) ${TOPDIR}/.config/x11/xresources ${HOME}/.Xresources;

# .ONESHELL:
# app: ## initialize ${HOME}/.local/bin/hjapps
# 	for item in $(APP); do
# 		$(MKDIR) ${HOME}/.local/bin/hjapps;
# 	    test -L ${HOME}/.local/bin/hjapps/$$item && continue || $(RMDIR) ${HOME}/.local/bin/hjapps/$$item;
# 	    $(LN) {${TOPDIR},${HOME}}/.local/bin/hjapps/$$item;
# 	done

# .ONESHELL:
# cmd: ## initialize ${HOME}/.local/bin/hjcmds
# 	for item in $(CMD); do
# 	    $(MKDIR) ${HOME}/.local/bin/hjcmds;
# 	    test -L ${HOME}/.local/bin/hjcmds/$$item && continue || $(RMDIR) ${HOME}/.local/bin/hjcmds/$$item;
# 	    $(LN) {${TOPDIR},${HOME}}/.local/bin/hjcmds/$$item;
# 	done

.ONESHELL:
bin: ## initialize ${HOME}/.local/bin/hjcmds
	for item in $(BIN); do
	    $(MKDIR) ${HOME}/.local/bin;
	    test -L ${HOME}/.local/bin/$$item && continue || $(RMDIR) ${HOME}/.local/bin/$$item;
	    $(LN) {${TOPDIR},${HOME}}/.local/bin/$$item;
	done

.ONESHELL:
etc: ## initialize /etc
	for item in $(ETC); do
	    sudo test -L /etc/$$item && continue || sudo $(RMDIR) /etc/$$item;
	    sudo $(LN) {${TOPDIR},}/etc/$$item;
	done

.ONESHELL:
src: ## initialize $HOME/.local/src/
	for item in $(SRC); do
		$(MKDIR) ${HOME}/.local/src;
	    test -L ${HOME}/.local/src/$$item && continue || $(RMDIR) ${HOME}/.local/src/$$item;
	    $(LN) {${TOPDIR},${HOME}}/.local/src/$$item;
	done

.ONESHELL:
share: ## initialize $HOME/.local/share/
	for item in $(SHARE); do
		$(MKDIR) ${HOME}/.local/share;
	    test -L ${HOME}/.local/share/$$item && continue || $(RMDIR) ${HOME}/.local/share/$$item;
	    $(LN) {${TOPDIR},${HOME}}/.local/share/$$item;
	done

.ONESHELL:
init: config bin etc src share cache ## initialize dotfiles and config
	test -L ${HOME}/.zshrc || $(RM) ${HOME}/.zshrc
	$(LN) {${TOPDIR}/.config/zsh,${HOME}}/.zshrc
	test -L ${HOME}/.zshenv || $(RM) ${HOME}/.zshenv
	$(LN) ${TOPDIR}/.config/shell/profile ${HOME}/.zshenv
	test -L ${HOME}/.pam_environment || $(RM) ${HOME}/.pam_environment
	$(LN) {${TOPDIR},${HOME}}/.pam_environment
	test -L ${HOME}/.ipython || $(RMDIR) ${HOME}/.ipython
	test -L ${HOME}/.gnuplot || $(RM) ${HOME}/.gnuplot
	$(LN) {${TOPDIR},${HOME}}/.gnuplot
	$(LNDIR) {${TOPDIR},${HOME}}/.ipython
	test -L ${HOME}/.vim || $(RMDIR) ${HOME}/.vim
	$(LNDIR) ${TOPDIR}/.config/nvim ${HOME}/.vim

.ONESHELL:
cache:
	[ ! -d ${HOME}/.cache/zsh ] && mkdir ${HOME}/.cache/zsh

.ONESHELL:
pacman:	## pacman setting
	sudo sed -i 's/#Color/Color\nILoveCandy\nParallelDownloads = 5/g' /etc/pacman.conf ## color
	sudo sed -i 's/#SigLevel = PackageRequired/SigLevel = PackageRequired/g' /etc/pacman.conf
	# repoList="core extra community multilib"
	# set -- $$repoList
	# for repo do
	# 	awk -v repo=$$repo -F "\n" '{}'
	# 	sudo sed "s/#\[$$repo/\[$$repo/g" /etc/pacman.conf ## comment out multilib
	# done
		# sudo sed 's/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf

		# sudo sed -i 's/#\[multilib/\[multilib/g' /etc/pacman.conf ## comment out multilib
		# sudo sed -i 's/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf

.ONESHELL:
aur: ## install Aur helper: using paru
	$(PACMAN) git base-devel
	sudo -u "$$USER" git clone https://aur.archlinux.org/paru-bin.git ${TOPDIR}/.local/src/paru-bin
	cd ${TOPDIR}/.local/src/paru-bin
	sudo -u "$$USER" -D ${TOPDIR}/.local/src/paru-bin makepkg --noconfirm -si
	cd -
	# $(RMDIR) ${TOPDIR}/paru

neovim: ## install and initiate neovim
	$(PACMAN) $@
	$(AUR) $@-remote

IME: ## Use fcitx as IME
	$(PACMAN) fcitx fcitx-configtool fcitx-qt5 fcitx-chewing fcitx-mozc
	test -L ${HOME}/.config/fcitx || $(RMDIR) ${HOME}/.config/fcitx
	$(LNDIR) {${TOPDIR},${HOME}}/.config/fcitx
	test -L ${HOME}/.pam_environment || $(RM) ${HOME}/.pam_environment
	$(LN) {${TOPDIR},${HOME}}/.pam_environment

browser: ## install browser
	$(PACMAN) firefox chromium

pdf: ## install and setup pdf software
	$(PACMAN) okular zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps xournalpp
	test -L ${HOME}/.config/okularpartrc || $(RM) ${HOME}/.config/okularpartrc
	$(LN) {${TOPDIR}/.config,${HOME}/.config}/okularpartrc

megasync: ## Mega Linux client
	$(AUR) $@-bin

transmission: ## Install torrent client
	$(PACMAN) $@-cli $@-qt


awk: ## Install different version of awk
	$(PACMAN) nawk gawk
	$(AUR) mawk goawk

mtools: ## A collection of utilities to access MS-DOS disks
	$(PACMAN) $@

arandr: ## install arandr
	$(PACMAN) $@

peek: ## install peek
	$(PACMAN) $@

zoom: ## install zoom
	$(AUR) $@



remarkable: ## install remarkable related software
	$(AUR) remarkable-mouse restream-git rmapi rmview-git

virtualbox: ## install virtualbox related software
	## Do not use virtualbox-guest-iso; the Windows 7 only allow version 6.10
	$(PACMAN) $@ $@-host-modules-arch
	$(AUR) $@-ext-oracle
	sudo usermod -a -G vboxusers $$USER
	sudo modprobe vboxdrv

pulseaudio: ## install pulseaudio
	$(PACMAN) $@ $@-alsa $@-bluetooth $@-equalizer $@-jack $@-lirc $@-rtp $@-zeroconf pulsemixer

bluetooth:
	$(PACMAN) bluez bluez-utils
	sudo systemctl enable bluetooth.service
	sudo systemctl start bluetooth.service

.ONESHELL:
python: ## install python
	$(PACMAN) $@ i$@
	$(PACMAN) $@-antlr4
	$(PACMAN) $@-appdirs
	$(PACMAN) $@-argon2_cffi
	$(PACMAN) $@-asn1crypto
	$(PACMAN) $@-astroid
	$(PACMAN) $@-async_generator
	$(PACMAN) $@-attrs
	$(PACMAN) $@-automat
	$(PACMAN) $@-babel
	$(PACMAN) $@-backcall
	$(PACMAN) $@-bcrypt
	$(PACMAN) $@-beautifulsoup4
	$(PACMAN) $@-bleach
	$(PACMAN) $@-blosc
	$(PACMAN) $@-bottleneck
	$(PACMAN) $@-cachecontrol
	$(PACMAN) $@-cairo
	$(PACMAN) $@-certifi
	$(PACMAN) $@-cffi
	$(PACMAN) $@-chardet
	$(PACMAN) $@-click
	$(PACMAN) $@-colorama
	$(PACMAN) $@-constantly
	$(PACMAN) $@-contextlib2
	$(PACMAN) $@-cryptography
	$(PACMAN) $@-cycler
	$(PACMAN) $@-dateutil
	$(PACMAN) $@-debugpy
	$(PACMAN) $@-decorator
	$(PACMAN) $@-defusedxml
	$(PACMAN) $@-deprecation
	$(PACMAN) $@-distlib
	$(PACMAN) $@-distro
	$(PACMAN) $@-dnspython
	$(PACMAN) $@-docopt
	$(PACMAN) $@-docutils
	$(PACMAN) $@-entrypoints
	$(PACMAN) $@-et-xmlfile
	$(PACMAN) $@-evdev
	$(PACMAN) $@-ewmh
	$(PACMAN) $@-gmpy2
	$(PACMAN) $@-gobject
	$(PACMAN) $@-gpgme
	$(PACMAN) $@-greenlet
	$(PACMAN) $@-html5lib
	$(PACMAN) $@-hyperlink
	$(PACMAN) $@-idna
	$(PACMAN) $@-imagesize
	$(PACMAN) $@-importlib-metadata
	$(PACMAN) $@-incremental
	$(PACMAN) $@-ipykernel
	$(PACMAN) $@-ipywidgets
	$(PACMAN) $@-isort
	$(PACMAN) $@-jdcal
	$(PACMAN) $@-jedi
	$(PACMAN) $@-jinja
	$(PACMAN) $@-joblib
	$(PACMAN) $@-jsonschema
	$(PACMAN) $@-jupyter_client
	$(PACMAN) $@-jupyter_core
	$(PACMAN) $@-jupyter_packaging
	$(PACMAN) $@-keyutils
	$(PACMAN) $@-kiwisolver
	$(PACMAN) $@-lazy-object-proxy
	$(PACMAN) $@-libevdev
	$(PACMAN) $@-lxml
	$(PACMAN) $@-markdown
	$(PACMAN) $@-markupsafe
	$(PACMAN) $@-matplotlib
	$(PACMAN) $@-matplotlib-inline
	$(PACMAN) $@-mccabe
	$(PACMAN) $@-mistune
	$(PACMAN) $@-mock
	$(PACMAN) $@-more-itertools
	$(PACMAN) $@-mpmath
	$(PACMAN) $@-msgpack
	$(PACMAN) $@-nest_asyncio
	$(PACMAN) $@-nose
	$(PACMAN) $@-numexpr
	$(PACMAN) $@-numpy
	$(PACMAN) $@-ipdb
	$(PACMAN) $@-openpyxl
	$(PACMAN) $@-ordered-set
	$(PACMAN) $@-os-service-types
	$(PACMAN) $@-packaging
	$(PACMAN) $@-pandas
	$(PACMAN) $@-seaborn
	$(PACMAN) $@-pandas-datareader
	$(PACMAN) $@-tensorflow
	$(PACMAN) $@-pandocfilters
	$(PACMAN) $@-paramiko
	$(PACMAN) $@-parso
	$(PACMAN) $@-patsy
	$(PACMAN) $@-pbr
	$(PACMAN) $@-pep517
	$(PACMAN) $@-pexpect
	$(PACMAN) $@-pickleshare
	$(PACMAN) $@-pillow
	$(PACMAN) $@-pip
	$(PACMAN) $@-ply
	$(PACMAN) $@-progress
	$(PACMAN) $@-prometheus_client
	$(PACMAN) $@-prompt_toolkit
	$(PACMAN) $@-psutil
	$(PACMAN) $@-ptyprocess
	$(PACMAN) $@-pyaml
	$(PACMAN) $@-pycparser
	$(PACMAN) $@-pycups
	$(PACMAN) $@-pycurl
	$(PACMAN) $@-pygments
	$(PACMAN) $@-pyhamcrest
	$(PACMAN) $@-pylint
	$(PACMAN) $@-pynacl
	$(PACMAN) $@-pynvim
	$(PACMAN) $@-pyopenssl
	$(PACMAN) $@-pyparsing
	$(PACMAN) $@-pyqt5
	$(PACMAN) $@-pyqt5-sip
	$(PACMAN) $@-pyrsistent
	$(PACMAN) $@-pysocks
	$(PACMAN) $@-pytables
	$(PACMAN) $@-pytz
	$(PACMAN) $@-pywal
	$(PACMAN) $@-pyxdg
	$(PACMAN) $@-pyzmq
	$(PACMAN) $@-qtpy
	$(PACMAN) $@-requests
	$(PACMAN) $@-resolvelib
	$(PACMAN) $@-retrying
	$(PACMAN) $@-scikit-build
	$(PACMAN) $@-scikit-learn
	$(PACMAN) $@-scipy
	$(PACMAN) $@-send2trash
	$(PACMAN) $@-setproctitle
	$(PACMAN) $@-setuptools
	$(PACMAN) $@-six
	$(PACMAN) $@-snowballstemmer
	$(PACMAN) $@-soupsieve
	$(PACMAN) $@-sphinx
	$(PACMAN) $@-sphinx-alabaster-theme
	$(PACMAN) $@-sphinxcontrib-applehelp
	$(PACMAN) $@-sphinxcontrib-devhelp
	$(PACMAN) $@-sphinxcontrib-htmlhelp
	$(PACMAN) $@-sphinxcontrib-jsmath
	$(PACMAN) $@-sphinxcontrib-qthelp
	$(PACMAN) $@-sphinxcontrib-serializinghtml
	$(PACMAN) $@-sqlalchemy
	$(PACMAN) $@-statsmodels
	$(PACMAN) $@-stem
	$(PACMAN) $@-sympy
	$(PACMAN) $@-terminado
	$(PACMAN) $@-testfixtures
	$(PACMAN) $@-testpath
	$(PACMAN) $@-threadpoolctl
	$(PACMAN) $@-toml
	$(PACMAN) $@-tomli
	$(PACMAN) $@-tomlkit
	$(PACMAN) $@-tornado
	$(PACMAN) $@-traitlets
	$(PACMAN) $@-twisted
	$(PACMAN) $@-urllib3
	$(PACMAN) $@-wcwidth
	$(PACMAN) $@-webencodings
	$(PACMAN) $@-wheel
	$(PACMAN) $@-wrapt
	$(PACMAN) $@-xlib
	$(PACMAN) $@-xlrd
	$(PACMAN) $@-xlsxwriter
	$(PACMAN) $@-xlwt
	$(PACMAN) $@-yaml
	$(PACMAN) $@-zipp
	$(PACMAN) $@-zope-interface
	$(PACMAN) $@-unidecode
	$(AUR) $@-jupytext $@-lxml

r: ## install r
	$(PACMAN) $@

go: ## install go
	$(PACMAN) $@

rust: ## install rust
	$(PACMAN) $@

c: ## install c
	$(PACMAN) gcc

fortran: ## install gfortran and intel fortran
	$(PACMAN) gcc-$@


.ONESHELL:
matlab: ## MANUALLY install matlab
	$(AUR) libxcrypt-compat
	[ ! -d matlab_R2022b_glnxa64 ] && \
		mkdir ${HOME}/HJCsrc/matlab_R2022b_glnxa64 && \
		unzip -X -K -d "${HOME}/HJCsrc/matlab_R2022b_glnxa64" "${HOME}/HJCsrc/matlab_R2022b_glnxa64.zip" && \
		cd "${HOME}/HJCsrc/matlab_R2022b_glnxa64" && \
		cd bin/glnxa64 && \
		mkdir exclude && \
		mv libfreetype.so.6 exclude/ && \
		mv libfreetype.so.6.16.0 exclude/ && \
		cd ../../
	sudo ./install
	sudo /usr/local/MATLAB/R2022b/bin/activate_matlab.sh
	cd ${TOPDIR}

proglang: awk python r go rust c fortran ## install programming languages

joplin: ## install joplin
	$(AUR) $@ $@-desktop

rclone: ## Init rclone
	$(PACMAN) $@
	chmod 600 ${PWD}/.config/rclone/rclone.conf
	test -L ${HOME}/.config/rclone || rm -rf ${HOME}/.config/rclone
	$(LNDIR) ${PWD}/.config/rclone ${HOME}/.config/rclone

# gnupg: rclone ## Deploy gnupg (Run after rclone)
# 	$(PACMAN) $@ git-crypt
# 	mkdir -p ${HOME}/.$@
# 	ln -vsf {${PWD},${HOME}}/.$@/gpg-agent.conf

ssh: ## Init ssh
	$(PACMAN) open$@
	mkdir -p ${HOME}/.$@
	ln -vsf {${PWD},${HOME}}/.ssh/{config,known_hosts}
	chmod 600 ${HOME}/.ssh/id_rsa

misc: ## misc software installation
	$(PACMAN) fzf flameshot screenkey \
     		  libreoffice-fresh libreoffice-extension-texmaths libreoffice-extension-writer2latex \
			  wget inkscape
	$(AUR) sent dragon-drop

printer: ## install printer required software and setting
	$(PACMAN) cups hplip system-config-printer

image: ## install image related software
	$(PACMAN) ueberzug chafa sxiv imagemagick

video: ## install video related software
	$(PACMAN) ffmpeg ffmpegthumbnailer mpv

sound: # install sound software
	$(PACMAN) mpd mpc ncmpcpp

backup: ## Backup arch linux packages
	mkdir -p ${PWD}/archlinux
	pacman -Qnq > ${PWD}/archlinux/pacmanlist
	pacman -Qqem > ${PWD}/archlinux/aurlist

.ONESHELL:
terminal: ## download terminal emulator
	$(PACMAN) alacritty rxvt-unicode rxvt-unicode-terminfo
	cd ./.local/src/st
	sudo make install
	cd -

.ONESHELL:
mjcli: ## install mjcli for latex to html math transform
	$(PACMAN) npm nodejs
	git clone https://github.com/michal-h21/$@ $(TOPDIR)/.local/bin/$@
	cd "$(TOPDIR)/.local/bin/$@"
	$(NPM) -g
	$(NPM) mathjax-full yargs
	cd $(TOPDIR)

.ONESHELL:
latex: mjcli ## install latex system
	$(PACMAN) biber texlive texlive-lang texlive-langextra texlive-bibtexextra
	$(AUR) mathpix-snipping-tool

html: ## html generation from markdown
	$(PACMAN) lowdown

.ONESHELL:
shell: ## install shell I need
	$(PACMAN) zsh bash
	$(AUR) zsh-fast-syntax-highlighting
	chsh -s /bin/zsh

.ONESHELL:
clipboard: ## install clipboard
	$(PACMAN) xclip xsel

.ONESHELL:
wm: ## install windows manager
	cd ${TOPDIR}/.local/src/dwm
	sudo make install
	cd -
	cd ${TOPDIR}/.local/src/dwmblocks
	sudo make install
	cd -
	cd ${TOPDIR}/.local/src/dmenu
	sudo make install
	cd -
	$(AUR) tzupdate

.ONESHELL:
xorg: ## install xorg related
	$(PACMAN) xorg-appres xorg-bdftopcf xorg-font-util xorg-fonts-encodings xorg-mkfontscale xorg-server xorg-server-common xorg-setxkbmap xorg-twm xorg-xauth xorg-xbacklight xorg-xclock xorg-xdpyinfo xorg-xev xorg-xeyes xorg-xhost xorg-xinit xorg-xinput xorg-xkbcomp xorg-xkill xorg-xmodmap xorg-xprop xorg-xrandr xorg-xrdb xorg-xset xorg-xsetroot xorg-xwininfo
	$(PACMAN) xdotool xdo xdg-utils xcompmgr wmctrl xcape
	sudo gpasswd -a huijunchen video # for xbacklight

.ONESHELL:
theme: ## install theme, right now for breeze
	$(PACMAN) breeze breeze-gtk breeze-icons breeze-grub
	# $(AUR) xcursor-breeze

.ONESHELL:
nvidia: ## install nvidia if there is nvidia driver
	$(PACMAN) nvidia nvidia-utils xorg-server-devel opencl-nvidia nvidia-settings
	$(PACMAN) mesa mesa-demos mesa-libgl xf86-video-nouveau

.ONESHELL:
core: ## install coreutils and other utils
	$(PACMAN) coreutils rsync ncdu mlocate man-db man-pages inetutils

.ONESHELL:
font: ## install font
	$(PACMAN) ttf-linux-libertine \
		      ttf-inconsolata \
			  ttf-fira-sans \
			  noto-fonts \
			  adobe-source-han-sans-cn-fonts \
			  adobe-source-han-sans-tw-fonts \
			  adobe-source-han-serif-cn-fonts \
			  adobe-source-han-serif-tw-fonts \
			  adobe-source-han-sans-jp-fonts \
			  adobe-source-han-serif-jp-fonts \
			  adobe-source-han-sans-kr-fonts \
			  adobe-source-han-serif-kr-fonts
	$(AUR) consolas-font \
		   ttf-century-gothic \
		   ttf-ms-fonts
	sudo fc-cache

filepreview: ## Terminal file manager file preview
	$(PACMAN) bat gnumeric odt2txt catdoc docx2txt poppler ffmpegthumbnailer perl-image-exiftool ueberzug

kernel: ## install linux kernel
	$(PACMAN) linux linux-header

compress: ## install (de-)compression stuff
	$(PACMAN) p7zip

desktop: wm xorg font theme transmission printer filepreview ## install my desktop system
	$(PACMAN) pcmanfm gvim
	# $(PACMAN) lxqt networkmanager libstatgrab libsysstat

all: aur pacman init allinstall

update: ## Update arch linux packages and save packages cache 3 generations
	$(AUR)yu; paccache -ruk0

manual: matlab ## install matlab and intel fortran
	${HOME}/HJCsrc/fortran/l_fortran-compiler_p_2022.0.2.83_offline.sh

allinstall: IME browser shell megasync mtools zoom remarkable virtualbox neovim pdf peek misc sound image video terminal latex clipboard core proglang desktop manual
