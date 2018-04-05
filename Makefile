# Installs multiple packages on Ubuntu 18.04 (Bionic Beaver)
# Inspired by and loosely based on https://gist.github.com/h4cc/c54d3944cb555f32ffdf25a5fa1f2602
# Feel free to use this if you would like to.

.PHONY:	all preparations libs update upgrade fonts gnome atom vscode python ruby vagrant graphics obs cad 3dprint darktable networking harddisk google_chrome archives media pandoc system virtualbox ansible docker filesystem tools teamviewer unetbootin steam libreoffice_full simplenote scribus mono monodevelop dosbox wine unity3d unifi lastpass kdenlive gitkraken googleplaymusic skype telegram slic3r_master driverppa pts

all:
	@echo "Installation of ALL targets"
	make preparations libs
	make update
	make upgrade
	make gnome
	make python
	make atom
	make vscode
	make graphics darktable
	make cad
	make 3dprint
	make obs
	make networking google_chrome
	# make dropbox
	make harddisk
	make media
	make pandoc
	make archives system filesystem tools
	make ansible virtualbox vagrant
	make docker
	make teamviewer
	make steam
	make libreoffice_full
	make simplenote
	make scribus
	make unetbootin
	make mono
	make monodevelop
	make dosbox wine
	make kdenlive
	make gitkraken
	make googleplaymusic
	make skype telegram
	make pts
	# make fonts

preparations:
	sudo apt-add-repository universe
	sudo apt-add-repository multiverse
	sudo apt-add-repository restricted
	make update
	sudo apt -y install software-properties-common build-essential checkinstall wget curl git libssl-dev apt-transport-https ca-certificates flatpak gnome-software-plugin-flatpak

libs:
	sudo apt -y install libavahi-compat-libdnssd-dev

update:
	sudo apt clean all
	sudo apt update

upgrade:
	sudo apt -y full-upgrade
	sudo snap refresh
	sudo flatpak update

fonts:
	sudo apt -y install ttf-mscorefonts-installer # Install Microsoft fonts.
	mkdir -p ~/.fonts/
	sudo apt -y install fonts-firacode fonts-hack\* fonts-cantarell lmodern ttf-aenigma ttf-georgewilliams ttf-bitstream-vera ttf-sjfonts tv-fonts
	# Install all the google fonts
	curl https://raw.githubusercontent.com/dylanmtaylor/Web-Font-Load/master/install.sh | sudo bash
	# Refresh font cache
	fc-cache -v

gnome:
	# Default GDM is pretty ugly. This forces upstream GDM theming.
	sudo apt -y install gnome-session vanilla-gnome-default-settings gnome-weather gnome-maps evolution
	sudo update-alternatives --set gdm3.css /usr/share/gnome-shell/theme/gnome-shell.css
	# Caffeine shell extenstion
	rm -rf gnome-shell-extension-caffeine
	git clone git://github.com/eonpatapon/gnome-shell-extension-caffeine.git
	./gnome-shell-extension-caffeine/update-locale.sh
	bash -c 'cd gnome-shell-extension-caffeine && glib-compile-schemas --strict --targetdir=caffeine@patapon.info/schemas/ caffeine@patapon.info/schemas'
	mkdir -p ~/.local/share/gnome-shell/extensions/
	cp -r gnome-shell-extension-caffeine/caffeine@patapon.info ~/.local/share/gnome-shell/extensions/

atom:
	curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
	sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
	make update
	sudo apt -y install gconf-service gconf2 gir1.2-gnomekeyring-1.0
	sudo apt -y install atom

vscode:
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	make update
	sudo apt-get install code

python:
	make preparations
	sudo -H apt -y install python-pip python-minimal
	sudo -H pip install --upgrade pip

ruby:
	sudo apt -y install ruby ruby-dev ruby-bundler jekyll
	sudo gem install bundler

vagrant:
	sudo apt -y install vagrant

graphics:
	# Remove apt package if installed and install the official flatpak version of GIMP as it more closely follows upstream GIMP vesrions
	sudo apt -y remove gimp
	if flatpak list | grep org.gimp.GIMP/x86_64/stable; then echo GIMP is already installed; else sudo flatpak install -y https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref; fi
	# The latest Krita is installed using the Krita Lime ppa
	sudo add-apt-repository -y ppa:kritalime/ppa
	sudo apt -y install krita
	# Inkscape's latest supported release is officially released as a PPA package.
	sudo add-apt-repository -y ppa:inkscape.dev/stable
	sudo apt -y install inkscape
	# Install additional graphics packages
  sudo apt -y install graphviz dia libav-tools jpegoptim mesa-utils

obs:
	sudo apt -y install obs-studio

cad:
	sudo apt -y install freecad

3dprint:
	sudo apt -y install cura libcanberra-gtk-module #libcanberra-gtk-module:i386
	# Get Slic3r from master
	sudo apt -y remove slic3r
	make slic3r_master
	# Prusa MK2s Slic3r settings
	mkdir -p $$HOME/.Slic3r/
	rm -rf Slic3r-settings
	git clone https://github.com/prusa3d/Slic3r-settings.git
	rsync -avzh Slic3r-settings/Slic3r\ settings\ MK2S\ MK2MM\ and\ MK3/ $$HOME/.Slic3r/

darktable:
	sudo apt -y install darktable

networking:
	sudo apt -y install pidgin filezilla vinagre remmina pepperflashplugin-nonfree hexchat wireshark-gtk zenmap samba ethtool sshuttle

harddisk:
	sudo apt -y install smartmontools nvme-cli smart-notifier #gsmartcontrol

google_chrome:
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
	wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	make update
	sudo apt -y install google-chrome-stable libappindicator1 libindicator7

dropbox:
	sudo apt -y install nautilus-dropbox

archives:
	sudo apt -y install unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller

media:
	sudo apt -y install mplayer mplayer-gui vlc ubuntu-restricted-extras libavcodec-extra libdvdread4 blender totem okular okular-extra-backends audacity brasero handbrake
	sudo apt -y install libxvidcore4 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad gstreamer1.0-alsa gstreamer1.0-fluendo-mp3 gstreamer1.0-libav
	# DVD Playback
	sudo apt -y install libdvd-pkg
	sudo dpkg-reconfigure libdvd-pkg
	# Fix mplayer bug - "Error in skin config file on line 6: PNG read error in /usr/share/mplayer/skins/default/main"
	cd /usr/share/mplayer/skins/default; for FILE in *.png ; do sudo convert $$FILE -define png:format=png24 $$FILE ; done

pandoc:
	sudo apt -y install pandoc pandoc-citeproc dvipng perl-tk fonts-lmodern fonts-texgyre lmodern tex-gyre
	# sudo apt -y install texlive texlive-latex-extra texlive-latex-base texlive-fonts-recommended texlive-latex-recommended texlive-latex-extra texlive-lang-german texlive-xetex preview-latex-style nbibtex

system:
	sudo apt -y install icedtea-8-plugin openjdk-8-jre subversion rabbitvcs-nautilus git git-gui curl vim network-manager-openvpn gparted gnome-disk-utility usb-creator-gtk traceroute cloc whois mssh inotify-tools openssh-server sqlite3 etckeeper stress gksu ntp heaptrack heaptrack-gui neovim powertop synaptic gdebi-core
	# sudo powertop --auto-tune
	sudo apt-add-repository -y ppa:teejee2008/ppa
	sudo apt -y install ukuu

virtualbox:
	sudo apt -y install virtualbox-modules virtualbox-guest-utils virtualbox-guest-additions-iso virtualbox virtualbox-guest-dkms

ansible:
	sudo apt -y install ansible

docker:
	sudo snap install docker

filesystem:
	sudo apt -y install cryptsetup libblockdev-crypto2 exfat-fuse exfat-utils e2fsprogs mtools dosfstools hfsutils hfsprogs jfsutils util-linux lvm2 nilfs-tools ntfs-3g reiser4progs reiserfsprogs xfsprogs attr quota f2fs-tools sshfs go-mtpfs jmtpfs

tools:
	sudo apt -y install htop meld guake keepassx retext vim geany glade ghex myrepos baobab byobu gnome-tweaks pv fortune cowsay lolcat screenfetch autokey-gtk shutter

teamviewer:
	sudo apt -y install qml-module-qtquick-dialogs qml-module-qtquick-privatewidgets
	# I really wish TeamViewer had a repository or something
	rm -f teamviewer_amd64.deb
	wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
	sudo dpkg -i teamviewer_amd64.deb
	rm -f teamviewer_amd64.deb

unetbootin:
	# workaround
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D45DF2E8FC91AE7E
	echo "deb http://ppa.launchpad.net/gezakovacs/ppa/ubuntu artful main" | sudo tee /etc/apt/sources.list.d/gezakovacs-ubuntu-ppa-bionic.list
	sudo apt-get update
	sudo apt-get -y install unetbootin

steam:
	sudo apt -y install python-apt
	rm -f steam.deb
	wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
	sudo dpkg -i steam.deb

libreoffice_full:
	# Remove the version of LibreOffice that ships with Ubuntu and install the upstream flatpak version
	sudo apt -y remove libreoffice libreoffice-base libreoffice-calc libreoffice-core libreoffice-draw libreoffice-impress
	if flatpak list | grep org.libreoffice.LibreOffice/x86_64/stable; then echo LibreOffice is already installed; else sudo flatpak install -y https://flathub.org/repo/appstream/org.libreoffice.LibreOffice.flatpakref; fi

simplenote:
	sudo snap install simplenote --edge

scribus:
	sudo apt -y install scribus

mono:
	sudo apt -y install mono-complete

monodevelop:
	sudo flatpak install -y https://download.mono-project.com/repo/monodevelop.flatpakref

dosbox:
	sudo apt -y install dosbox

wine:
	# Based on https://wiki.winehq.org/Ubuntu
	rm -f winerelease.key
	wget -nc https://dl.winehq.org/wine-builds/Release.key -q -O winerelease.key
	sudo dpkg --add-architecture i386
	sudo apt-key add winerelease.key
	sudo apt-add-repository -s "deb https://dl.winehq.org/wine-builds/ubuntu/ artful main" #hack until bionic packages are released
	sudo apt -y install --install-recommends winehq-devel fonts-wine

unity3d:
	cat unity3d.desktop | sudo tee /usr/share/applications/unity3d.desktop
	rm -f UnitySetup-2018.1.0b8
	wget https://beta.unity3d.com/download/ee2fb9f9da52/UnitySetup-2018.1.0b8
	chmod +x UnitySetup-2018.1.0b8
	sudo ./UnitySetup-2018.1.0b8 --unattended -l /opt/Unity3D
	sudo chown -R $$USER:$$USER /opt/Unity3D

unifi:
	echo 'deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list
	sudo wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ubnt.com/unifi/unifi-repo.gpg
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50
	sudo apt-get update --allow-releaseinfo-change
	sudo apt -y install unifi

lastpass:
	wget -q https://lastpass.com/lplinux.tar.bz2 -O lplinux.tar.bz2
	tar xjvf lplinux.tar.bz2
	./install_lastpass.sh

kdenlive:
	if flatpak list | grep org.kde.kdenlive/x86_64/stable; then echo kdenlive is already installed; else sudo flatpak install -y https://flathub.org/repo/appstream/org.kde.kdenlive.flatpakref; fi

gitkraken:
	sudo snap install gitkraken

googleplaymusic:
	if flatpak list | grep com.googleplaymusicdesktopplayer.GPMDP/x86_64/stable; then echo Google Play Music is already installed; else sudo flatpak install -y https://flathub.org/repo/appstream/com.googleplaymusicdesktopplayer.GPMDP.flatpakref; fi

skype:
	if flatpak list | grep com.skype.Client/x86_64/stable; then echo Skype is already installed; else sudo flatpak install -y https://flathub.org/repo/appstream/com.skype.Client.flatpakref; fi

telegram:
	if flatpak list | grep org.telegram.desktop/x86_64/stable; then echo Telegram is already installed; else sudo flatpak -y install https://flathub.org/repo/appstream/org.telegram.desktop.flatpakref; fi

slic3r_master:
	cat slic3r_master.desktop | sudo tee /usr/share/applications/slic3r_master.desktop
	wget -N https://dl.slic3r.org/dev/linux/Slic3r-master-latest.tar.bz2
	sudo rm -rf /opt/Slic3r/
	sudo tar xvjf Slic3r-master-latest.tar.bz2 -C /opt/

driverppa:
	sudo add-apt-repository -y ppa:graphics-drivers/ppa

pts:
	sudo apt -y install phoronix-test-suite
