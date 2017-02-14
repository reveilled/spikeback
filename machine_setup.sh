stub()
{
	echo stub > /dev/null
}

#install nut and dependencies
nut_deps=(dh-autoreconf libusb* libsnmp-dev libneon27-dev libavahi-client-dev libavahi-common3 libavahi-core-dev libavahi-core7 libavahi-glib1 libavahi-glib-dev libavahi-common-dev libavahi1.0-cil libavahi-cil-dev powerman libpowerman0 libpowerman0 libpowerman0-dev nut-powerman-pdu libfreeipmi16 libfreeipmi16 freeipmi-* libipmi* libgd3 libgd-dev autoconf)

install_nut()
{
	wget http://www.networkupstools.org/source/2.7/nut-2.7.4.tar.gz
	tar -xzf nut-2.7.4.tar.gz 
	pushd nut-2.7.4/

	autoconf
	./configure --with-all
	make install
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
hackrf_deps=()
install_hackrf()
{
	stub
}

#install rtl-sdr software
rtl_sdr_deps=()
install_rtlsdr()
{
	stub
}

#install and configure GPIO

#install the wiki and 
wiki_deps=()
install_wiki()
{
	stub
}

#install apps I like
desktop_app_deps=(htop tmux vim)
install_desktop_apps()
{
	stub
}

sudo apt-get install ${desktop_app_deps[@]} ${nut_deps[@]} ${gnuradio_deps[@]} ${hackrf_deps[@]} ${rtl_sdr_deps[@]} ${wiki_deps[@]} 
install_nut
install_gnuradio
install_hackrf
install_rtlsdr
install_wiki
install_desktop_apps
