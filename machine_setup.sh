stub()
{
	echo "stub" > /dev/null
}

#install nut and dependencies
#nut_deps=(dh-autoreconf libusb* libsnmp-dev libneon27-dev libavahi-client-dev libavahi-common3 libavahi-core-dev libavahi-core7 libavahi-glib1 libavahi-glib-dev libavahi-common-dev libavahi1.0-cil libavahi-cil-dev powerman libpowerman0 libpowerman0 libpowerman0-dev nut-powerman-pdu libfreeipmi16 libfreeipmi16 freeipmi-* libipmi* libgd3 libgd-dev autoconf)

nut_deps=(nut nut-server nut-client)

install_nut()
{
#	wget http://www.networkupstools.org/source/2.7/nut-2.7.4.tar.gz
#	tar -xzf nut-2.7.4.tar.gz 
#	pushd nut-2.7.4/
#
#	autoconf
#	./configure --with-all
#	make -j 4
#	sudo make install
#	popd

	pushd nut-files
	cd rules
	sudo cp * /etc/udev/rules.d
	sudo udevadm control --reload-rules
	cd ../config
	sudo cp * /etc/nut/
	popd

	#probably some ups configuration stuff
}

#get gnuradio repos and install them
gnuradio_deps=()
gnuradio_clone_and_install()
{
	local repo_url=$1
	local repo_name=`echo $1 | python -c "a=raw_input();print a.split('/')[-1].split('.')[0]"`

	#clone and go in
	git clone $repo_url
	pushd $repo_name

	git submodule update --init --recursive
	mkdir build
	cd build
	cmake ..
	make -j 8
	sudo make install
	popd
}


gnuradio_repos=(https://github.com/gnuradio/gnuradio.git\ 
https://github.com/osh/gr-eventstream.git)

install_gnuradio(){
	for r in ${gnuradio_repos[@]};
	do gnuradio_clone_and_install $r;
	done
}

#install hackrf software
hackrf_deps=(build-essential cmake libusb-1.0-0-dev pkg-config libfftw3-dev)
install_hackrf()
{
	sudo apt-get remove hackrf libhackrf0
	git clone https://github.com/mossmann/hackrf.git
	pushd hackrf

	mkdir host/build
	cd host/build
	cmake ..
	make -j 4
	sudo make install
	sudo ldconfig

	popd
}

#install rtl-sdr software
rtl_sdr_deps=()
install_rtlsdr()
{
	#blacklist the drivers that get in the way
	touch no-rtl.conf
	echo blacklist dvb_usb_rtl28xxu >> no-rtl.conf
	echo blacklist rtl2832 >> no-rtl.conf
	echo blacklist rtl2830 >> no-rtl.conf
	sudo mv no-rtl.conf /etc/modprobe.d

	git clone git://git.osmocom.org/rtl-sdr.git
	mkdir rtl-sdr/build
	pushd rtl-sdr/build
	cmake ../ -DINSTALL_UDEV_RULES=ON
	make -j 4
	sudo make install
	sudo ldconfig
	cd ..
	sudo cp rtl-sdr.rules /etc/udev/rules.d
	sudo udevadm control --reload-rules
	popd
	#reinit modprobe and udev
}

#install and configure GPIO

#install the wiki and 
wiki_deps=( mediawiki imagemagick)
install_wiki()
{
	#turns out this is offered at install
	#get the push extension
	#wget https://extdist.wmflabs.org/dist/extensions/Push-REL1_28-03290b5.tar.gz
	#sudo tar -xzf Push-REL1_28-03290b5.tar.gz -C /var/lib/mediawiki/extensions
	#configure push at some point

	#link in the wiki
	sudo ln -s /var/lib/mediawiki /var/www/html/wiki

	#set up mysql user
	mysql -u root -p < wiki_files/create_wiki_usr.sql

	#Have the installer actually configure the wiki
	echo Kindly install the wiki
	#get a user response
	read -n1 -r -p "Press any key to continue..." key

	#make sure you can upload large files and from websites
	echo "\$wgAllowCopyUploads=true;" >> /etc/mediawiki/LocalSettings.php
	echo "\$wgCheckFileExtensions=false;" >> /etc/mediawiki/LocalSettings.php
	#probably configure push here with some kind of appends
}

bitscope_deps=(libpango1.0-0 libpangox-1.0-0 libpangoxft-1.0-0 screen)
install_bitscope()
{
	mkdir bitscope_debs
	pushd bitscope_debs

	wget http://bitscope.com/download/files/bitscope-dso_2.8.FE22H_armhf.deb  
	wget http://bitscope.com/download/files/bitscope-logic_1.2.FC20C_armhf.deb 
	wget http://bitscope.com/download/files/bitscope-meter_2.0.FK22G_armhf.deb 
	wget http://bitscope.com/download/files/bitscope-chart_2.0.FK22M_armhf.deb 
	wget http://bitscope.com/download/files/bitscope-proto_0.9.FG13B_armhf.deb 
	wget http://bitscope.com/download/files/bitscope-console_1.0.FK29A_armhf.deb 
	wget http://bitscope.com/download/files/bitscope-display_1.0.EC17A_armhf.deb 
	wget http://bitscope.com/download/files/bitscope-server_1.0.FK26A_armhf.deb 

	#bitscope console is messed up until I can find bitscope-link
	sudo dpkg -i *.deb
	popd

	#Using the server as a service nuke the system log.
	#best use screen until the issue is resolved
	#copy in the service config and get it started
	#sudo cp bitscope_files/bitscope.service lib/systemd/system
	#sudo systemctl daemon-reload
	#sudo systemctl enable bitscope.service
	#sudo systemctl start bitscope.service

}

note_deps=(fswebcam avconv libv4l-* lame libx264* libasound2-dev libalsaplayer-dev oss-compat alsa-oss streamer python-poster tempfile)
install_note_taking()
{
	#load up kernel modules
	sudo modprobe snd_pcm_oss
	sudo modprobe snd_mixer_oss

	#set up the wiki botz

	#clone ffmpeg, consider using a prebuilt
	git clone git://source.ffmpeg.org/ffmpeg.git
	pushd ffmpeg
	./configure --enable-gpl --enable-libx264 --enable-mmal --enable-indev=alsa
	make
	sudo make install
	popd

}

labshell_deps=(dsh)
install_lab_shell()
{
	stub
}

python_deps=(python-argparse python-argcomplete python-crypto python-cryptography python-serial python-pexpect python-zmq python-scapy python-protobuf)
install_python_deps()
{
	stub
}

#install apps I like
#should probably add in some Bluetooth tools
desktop_app_deps=(htop tmux vim git build-essential cmake autoconf minicom)
install_desktop_apps()
{
	stub
}


sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y ${desktop_app_deps[@]} ${nut_deps[@]} ${gnuradio_deps[@]} ${hackrf_deps[@]} ${rtl_sdr_deps[@]} ${wiki_deps[@]} ${bitscope_deps[@]} ${labshell_deps[@]} ${python_deps[@]}
install_nut
install_gnuradio
install_hackrf
install_rtlsdr
install_wiki
install_bitscope
install_note_taking
install_lab_shell
install_python_deps
install_desktop_apps
sudo reboot
