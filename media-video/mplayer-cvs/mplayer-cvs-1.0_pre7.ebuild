# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mplayer/mplayer-1.0_pre7.ebuild,v 1.2 2005/04/17 14:05:35 lu_zero Exp $

inherit eutils flag-o-matic linux-mod cvs

#RESTRICT="nostrip"
IUSE="3dfx 3dnow 3dnowext aac aalib alsa altivec amr arts avi bidi bl cpudetection
custom-cflags debug dga dirac doc dts dvb cdparanoia directfb dv dvd dvdread
edl encode esd fbcon gif ggi gtk i8x0 ipv6 jack joystick jpeg libcaca lirc live lzo
mad matroska matrox mmx mmxext musepack mythtv nas nvidia vorbis opengl oss
png real rtc samba sdl speex sse sse2 svga tga theora truetype v4l v4l2 X x264
xanim xinerama xmms xv xvid xvmc gtk2"

BLUV=1.4
SVGV=1.9.17
NBV=540
WBV=520
NAV=20060306
SKINDIR="/usr/share/mplayer/skins/"

S="${WORKDIR}/main"
SRC_URI="mirror://mplayer/releases/fonts/font-arial-iso-8859-1.tar.bz2
	mirror://mplayer/releases/fonts/font-arial-iso-8859-2.tar.bz2
	mirror://mplayer/releases/fonts/font-arial-cp1250.tar.bz2
	svga? ( http://mplayerhq.hu/~alex/svgalib_helper-${SVGV}-mplayer.tar.bz2 )
	amr? ( http://www.3gpp.org/ftp/Specs/latest/Rel-5/26_series/26204-${WBV}.zip
		http://www.3gpp.org/ftp/Specs/latest/Rel-5/26_series/26104-${NBV}.zip )
	gtk? ( mirror://mplayer/Skin/Blue-${BLUV}.tar.bz2 )"

# Only install Skin if GUI should be build (gtk as USE flag)
DESCRIPTION="Media Player for Linux"
HOMEPAGE="http://www.mplayerhq.hu/"

# 'encode' in USE for MEncoder.
RDEPEND="xvid? ( >=media-libs/xvid-0.9.0 )
	x86? (
		avi? ( >=media-libs/win32codecs-20040916 )
		real? ( >=media-video/realplayer-10.0.3 )
		)
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )
	bidi? ( dev-libs/fribidi )
	cdparanoia? ( media-sound/cdparanoia )
	dga? ( virtual/x11 )
	directfb? ( dev-libs/DirectFB )
	dts? || ( media-libs/libdca media-libs/libdts )
	dvd? ( dvdread? ( media-libs/libdvdread ) )
	encode? (
		media-sound/lame
		media-sound/twolame
		dv? ( >=media-libs/libdv-0.9.5 )
		aac? ( media-libs/faac )
		)
	esd? ( media-sound/esound )
	gif? ( ||( media-libs/giflib media-libs/libungif ) )
	ggi? ( media-libs/libggi )
	gtk? (
		media-libs/libpng
		virtual/x11
		!gtk2? ( =x11-libs/gtk+-1.2* )
		gtk2? ( =x11-libs/gtk+-2* )
		)
	jpeg? ( media-libs/jpeg )
	libcaca? ( media-libs/libcaca )
	lirc? ( app-misc/lirc )
	lzo? ( dev-libs/lzo )
	mad? ( media-libs/libmad )
	nas? ( media-libs/nas )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng )
	samba? ( >=net-fs/samba-2.2.8a )
	sdl? ( media-libs/libsdl )
	svga? ( media-libs/svgalib )
	theora? ( media-libs/libtheora )
	live? ( >=media-plugins/live-2004.07.20 )
	truetype? ( >=media-libs/freetype-2.1 )
	xinerama? ( virtual/x11 )
	jack? ( jack-audio-connection-kit )
	xmms? ( media-sound/xmms )
	xanim? ( >=media-video/xanim-2.80.1-r4 )
	musepack? ( >=media-libs/libmpcdec-1.2.1 )
	dirac? ( >=media-video/dirac-0.5.2 )
	aac? ( media-libs/faad2 )
	x264? ( >=media-libs/x264-45 )
	speex? ( >=media-libs/speex-1.1.0 )
	sys-libs/ncurses"

DEPEND="${RDEPEND}
	doc? ( dev-libs/libxslt
		>=app-text/docbook-xml-dtd-4.1.2
		>=app-text/docbook-xsl-stylesheets-1.62.4 )
	app-arch/unzip"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

# ecpu_check
# Usage:
#
# ecpu_check array_of_cpu_flags
#
# array_of_cpu_flags - An array of cpu flags to check against USE flags
#
# Checks user USE related cpu flags against /proc/cpuinfo.  If user enables a
# cpu flag that is not supported in their processor flags, it will warn the
# user if CROSSCOMPILE is not set to 1 ( because cross compile users are
# obviously using different cpu flags than their own cpu ).  Examples:
#
# CPU_FLAGS=(mmx mmx2 sse sse2)
# ecpu_check CPU_FLAGS
# Chris White <chriswhite@gentoo.org> (03 Feb 2005)

ecpu_check() {
	# Think about changing below to: if [ "${CROSSCOMPILE}" -ne 1 -a -e "/proc/cpuinfo" ]
	# and dropping the else if you do not plan on adding anything to that
	# empty block ....
	# PS: also try to add some quoting, and consider rather using ${foo} than $foo ...
	if [ "${CROSSCOMPILE}" != "1" -a -e "/proc/cpuinfo" ]
	then
		CPU_FLAGS=${1}
		USER_CPU=`grep "flags" /proc/cpuinfo`

		for flags in `seq 1 ${#CPU_FLAGS[@]}`
		do
			if has ${CPU_FLAGS[${flags} - 1]} ${USER_CPU} && ! has ${CPU_FLAGS[${flags} - 1]} ${USE}
			then
				ewarn "Your system is ${CPU_FLAGS[${flags} - 1]} capable but you don't have it enabled!"
				ewarn "You might be cross compiling (in this case set CROSSCOMPILE to 1 to disable this warning."
			fi

			if ! has ${CPU_FLAGS[${flags} - 1]} ${USER_CPU}  && has ${CPU_FLAGS[${flags} -1]} ${USE}
			then
				ewarn "You have ${CPU_FLAGS[${flags} - 1]} support enabled but your processor doesn't"
				ewarn "seem to support it!  You might be cross compiling or do not have /proc filesystem"
				ewarn "enabled.  If either is the case, set CROSSCOMPILE to 1 to disable this warning."
			fi
		done
	fi
}

teh_conf() {
	# avoid using --enable-xxx options,
	# except {gui,debug} and those, disabled by default
	if ! use $1; then
		myconf="${myconf} --disable-$( [ -n "$2" ] && echo $2 || echo $1)"
	fi
}

pkg_setup() {
	if use real && use x86; then
				REALLIBDIR="/opt/RealPlayer/codecs"
	fi
	CHARSET="`locale charmap`"
}

src_unpack() {

	ECVS_SERVER="mplayerhq.hu:/cvsroot/mplayer"
	ECVS_MODULE="main" cvs_src_unpack
	ECVS_SERVER="mplayerhq.hu:/cvsroot/ffmpeg"
	ECVS_MODULE="ffmpeg/libavcodec" cvs_src_unpack
	ECVS_MODULE="ffmpeg/libavformat" cvs_src_unpack
	ECVS_MODULE="ffmpeg/libavutil" cvs_src_unpack

	cd ${WORKDIR}

	mv -f ffmpeg/libav{codec,format,util} main

	if use amr; then
		unpack 26104-${NBV}.zip 26204-${WBV}.zip
		unzip -ajq 26204-${WBV}_ANSI-C_source_code.zip -d ${S}/libavcodec/amrwb_float
		unzip -ajq 26104-${NBV}_ANSI_C_source_code.zip -d ${S}/libavcodec/amr_float
	fi

	unpack \
		font-arial-iso-8859-1.tar.bz2 font-arial-iso-8859-2.tar.bz2 \
		font-arial-cp1250.tar.bz2

	use svga && unpack svgalib_helper-${SVGV}-mplayer.tar.bz2

	use gtk && unpack Blue-${BLUV}.tar.bz2

	cd ${S}

	# Custom CFLAGS
	if use custom-cflags ; then
	sed -e 's:CFLAGS="custom":CFLAGS=${CFLAGS}:' -i configure
	fi

	# skip make distclean/depend
	touch .developer
	sed -i '/\$(MAKE) depend/d' Makefile

	if use svga
	then
		echo
		einfo "Enabling vidix non-root mode."
		einfo "(You need a proper svgalib_helper.o module for your kernel"
		einfo " to actually use this)"
		echo

		mv ${WORKDIR}/svgalib_helper ${S}/libdha
	fi

	use dirac && epatch ${FILESDIR}/mplayer-dirac-cvs.diff

	# cat a.avi b.avi | mencoder ...
	#epatch ${FILESDIR}/demuxavifix.patch

	EPATCH_SUFFIX="diff" epatch "${FILESDIR}"

	has_version '>=media-sound/twolame-0.3.4' && \
		sed -i 's:twolame_set_VBR_q:twolame_set_VBR_level:' libmpcodecs/ae_twolame.c
}

linguas_warn() {
	ewarn "Language ${LANG[0]} or ${LANG_CC} not avaliable"
	ewarn "Language set to English"
	ewarn "If this is a mistake, please set the"
	ewarn "First LINGUAS language to one of the following"
	ewarn ""
	ewarn "bg - Bulgarian"
	ewarn "cz - Czech"
	ewarn "de - German"
	ewarn "dk - Danish"
	ewarn "el - Greek"
	ewarn "en - English"
	ewarn "es - Spanish"
	ewarn "fr - French"
	ewarn "hu - Hungarian"
	ewarn "ja - Japanese"
	ewarn "ko - Korean"
	ewarn "mk - FYRO Macedonian"
	ewarn "nl - Dutch"
	ewarn "no - Norwegian"
	ewarn "pl - Polish"
	ewarn "pt_BR - Portuguese - Brazil"
	ewarn "ro - Romanian"
	ewarn "ru - Russian"
	ewarn "sk - Slovak"
	ewarn "tr - Turkish"
	ewarn "uk - Ukranian"
	ewarn "zh_CN - Chinese - China"
	ewarn "zh_TW - Chinese - Taiwan"
	export LINGUAS="en ${LINGUAS}"
}

src_compile() {

	# have fun with LINGUAS variable
	if [[ -n $LINGUAS ]]
	then
		# LINGUAS has stuff in it, start the logic
		LANG=( $LINGUAS )
		if [ -e ${S}/help/help_mp-${LANG[0]}.h ]
		then
			einfo "Setting MPlayer messages to language: ${LANG[0]}"
		else
			LANG_CC=${LANG[0]}
			if [ ${#LANG_CC} -ge 2 ]
			then
				LANG_CC=${LANG_CC:0:2}
				if [ -e ${S}/help/help_mp-${LANG_CC}.h ]
				then
					einfo "Setting MPlayer messages to language ${LANG_CC}"
					export LINGUAS="${LANG_CC} ${LINGUAS}"
				else
					linguas_warn
				fi
			else
				linguas_warn
			fi
		fi
	else
		# sending blank LINGUAS, make it default to en
		einfo "No LINGUAS given, defaulting to English"
		export LINGUAS="en ${LINGUAS}"
	fi


	# check cpu flags
	if use x86 && use !cpudetection
	then
		CPU_FLAGS=(3dnow 3dnowext mmx sse sse2 mmxext)
		ecpu_check CPU_FLAGS
	fi

	if use custom-cflags ; then
	# let's play the filtration game!  MPlayer hates on all!
	strip-flags

	#add -frename-registers per bug #75960
	append-flags -frename-registers

	# ugly optimizations cause MPlayer to cry on x86 systems!
	if use x86 ; then
		replace-flags -O0 -O2
		replace-flags -O3 -O2
		filter-flags -fPIC -fPIE
	fi
	fi


	local myconf=
	################
	#Optional features#
	###############
	myconf="${myconf} $(use_enable cpudetection runtime-cpudetection)"
	teh_conf bidi fribidi
	teh_conf cdparanoia
	if use dvd; then
		if use dvdread; then
			myconf="${myconf} --disable-mpdvdkit"
		else
			myconf="${myconf} --disable-dvdread"
		fi
	else
		myconf="${myconf} --disable-dvdread --disable-mpdvdkit"
	fi
	teh_conf edl

	if use encode ; then
		teh_conf dv libdv
	else
		myconf="${myconf} --disable-mencoder --disable-libdv"
	fi

	if use !gtk && use !X && use !xv && use !xinerama; then
		myconf="${myconf} --disable-gui --disable-x11 --disable-xv --disable-xmga --disable-xinerama --disable-vm --disable-xvmc"
	else
		#note we ain't touching --enable-vm.  That should be locked down in the future.
		myconf="${myconf} $(use_enable gtk gui)"
		teh_conf xinerama
		teh_conf xv
		use !gtk2 && myconf="${myconf} --enable-old-gtk"
	fi

	# this looks like a hack, but the
	# --enable-dga needs a paramter, but there's no surefire
	# way to tell what it is.. so I'm letting MPlayer decide
	# the enable part
	use !dga && myconf="${myconf} --disable-dga"

	# disable png *only* if gtk && png aren't on
	if ! use png || ! use gtk; then
		myconf="${myconf} --disable-png"
	fi
	teh_conf ipv6 inet6
	myconf="${myconf} $(use_enable joystick)"
	teh_conf lirc
	teh_conf live
	teh_conf rtc
	teh_conf samba smb
	teh_conf truetype freetype
	teh_conf v4l tv-v4l
	teh_conf v4l2 tv-v4l2
	use jack || myconf="${myconf} --disable-jack"

	#########
	# Codecs #
	########
	teh_conf gif
	teh_conf jpeg
	#teh_conf ladspa
	teh_conf dts libdts
	teh_conf lzo liblzo
	teh_conf matroska internal-matroska
	teh_conf aac external-faad
	if use aac; then
		myconf="${myconf} --disable-internal-faad"
	else
		use !encode && myconf="${myconf} --disable-faac"
	fi
	teh_conf vorbis
	teh_conf speex
	teh_conf theora
	use xmms && myconf="${myconf} --enable-xmms"
	teh_conf xvid
	teh_conf x264
	use x86 && teh_conf real
	use x86 && teh_conf avi win32
	teh_conf amr amr_nb
	teh_conf amr amr_wb
	myconf="${myconf} --disable-amr_nb-fixed"

	teh_conf musepack

	#############
	# Video Output #
	#############
	if use 3dfx; then
		myconf="${myconf} --enable-3dfx --enable-tdfxvid"
		use fbcon && myconf="${myconf} --enable-tdfxfb"
	else
		myconf="${myconf} --disable-tdfxvid"
	fi

	if use dvb ; then
		myconf="${myconf} --with-dvbincdir=/usr/src/linux/include"
	else
		myconf="${myconf} --disable-dvbhead"
	fi

	teh_conf aalib aa
	teh_conf directfb
	teh_conf fbcon fbdev
	teh_conf ggi
	teh_conf libcaca caca
	if use matrox && use X; then
		teh_conf matrox xmga
	fi
	teh_conf matrox mga
	teh_conf opengl gl
	teh_conf sdl

	teh_conf svga
	teh_conf svga vidix

	teh_conf tga

	( use xvmc && use nvidia ) \
		&& myconf="${myconf} --enable-xvmc --with-xvmclib=XvMCNVIDIA"

	( use xvmc && use i8x0 ) \
		&& myconf="${myconf} --enable-xvmc --with-xvmclib=I810XvMC"

	( use xvmc && use nvidia && use i8x0 ) \
		&& {
			eerror "Invalid combination of USE flags"
			eerror "When building support for xvmc, you may only"
			eerror "include support for one video card:"
			eerror "   nvidia, i8x0"
			eerror ""
			eerror "Emerge again with different USE flags"

			exit 1
		}

	( use xvmc && ! use nvidia && ! use i8x0 ) && {
		ewarn "You tried to build with xvmc support."
		ewarn "No supported graphics hardware was specified."
		ewarn ""
		ewarn "No xvmc support will be included."
		ewarn "Please one appropriate USE flag and re-emerge:"
		ewarn "   nvidia or i8x0"

		myconf="${myconf} --disable-xvmc"
	}

	#############
	# Audio Output #
	#############
	teh_conf alsa
	teh_conf arts
	teh_conf esd
	teh_conf mad
	teh_conf nas
	teh_conf oss ossaudio

	#################
	# Advanced Options #
	#################
	teh_conf 3dnow
	teh_conf 3dnowext 3dnowex;
	teh_conf sse
	teh_conf sse2
	teh_conf mmx
	teh_conf mmxext mmx2
	myconf="${myconf} $(use_enable debug)"

	# mplayer now contains SIMD assembler code for amd64
	# AMD64 Team decided to hardenable SIMD assembler for all users
	# Danny van Dyk <kugelfang@gentoo.org> 2005/01/11
	if use amd64; then
		myconf="${myconf} --enable-3dnow --enable-3dnowex --enable-sse --enable-mmx --enable-mmx2"
	fi

	if use ppc64
	then
		myconf="${myconf} --disable-altivec"
	else
		teh_conf altivec
		use altivec && append-flags -maltivec -mabi=altivec
	fi


	if use xanim
	then
		myconf="${myconf} --with-xanimlibdir=/usr/lib/xanim/mods"
	fi

	if [ -e /dev/.devfsd ]
	then
		myconf="${myconf} --enable-linux-devfs"
	fi

	use live && myconf="${myconf} --with-livelibdir=/usr/$(get_libdir)/live"

	# support for blinkenlights
	use bl && myconf="${myconf} --enable-bl"

	has_version '>=gnome-extra/gnome-screensaver-2.14.0' || myconf="${myconf} --disable-dbus-glib"

	#leave this in place till the configure/compilation borkage is completely corrected back to pre4-r4 levels.
	# it's intended for debugging so we can get the options we configure mplayer w/, rather then hunt about.
	# it *will* be removed asap; in the meantime, doesn't hurt anything.
	echo "${myconf}" > ${T}/configure-options

	./configure \
		--prefix=/usr \
		--confdir=/usr/share/mplayer \
		--datadir=/usr/share/mplayer \
		--enable-largefiles \
		--enable-menu \
		--with-reallibdir=${REALLIBDIR} \
		--with-x11incdir=/usr/X11R6/include \
		--charset=${CHARSET} \
		${myconf} || die

	# we run into problems if -jN > -j1
	# see #86245
	MAKEOPTS="${MAKEOPTS} -j1"

	einfo "Make"
	emake || die "Failed to build MPlayer!"
	if use doc; then
		make -C ${S}/DOCS/xml html-chunked-en
	fi
	einfo "Make completed"
}

src_install() {

	einfo "Make install"
	make prefix=${D}/usr \
	     BINDIR=${D}/usr/bin \
		 LIBDIR=${D}/usr/$(get_libdir) \
	     CONFDIR=${D}/usr/share/mplayer \
	     DATADIR=${D}/usr/share/mplayer \
	     MANDIR=${D}/usr/share/man \
	     install || die "Failed to install MPlayer!"
	einfo "Make install completed"

	dodoc AUTHORS ChangeLog README
	for i in DOCS TOOLS; do
		find "${S}/$i" -name CVS -type d | xargs rm -rf
	done
	# Install the documentation; DOCS is all mixed up not just html
	if use doc ; then
		#for dir in de it tech zh
		#	do cp -r "${S}/DOCS/$dir" "${D}/usr/share/doc/${PF}/"
		#done
		cp -r "${S}/DOCS/tech" "${D}/usr/share/doc/${PF}/"
		dohtml -r "${S}/DOCS/HTML/en/*"
	fi

	# Copy misc tools to documentation path, as they're not installed directly
	# and yes, we are nuking the +x bit.
	find "${S}/TOOLS" -type d | xargs -- chmod 0755
	find "${S}/TOOLS" -type f | xargs -- chmod 0644
	cp -r "${S}/TOOLS" "${D}/usr/share/doc/${PF}/" || die

	# Install the default Skin and Gnome menu entry
	if use gtk; then
		if [ -d "${ROOT}${SKINDIR}default" ]; then dodir ${SKINDIR}; fi
		cp -r ${WORKDIR}/Blue ${D}${SKINDIR}default || die

		# Fix the symlink
		rm -rf ${D}/usr/bin/gmplayer
		dosym mplayer /usr/bin/gmplayer
	fi

	dodir /usr/share/mplayer/fonts
	local x=
	# Do this generic, as the mplayer people like to change the structure
	# of their zips ...
	for x in $(find ${WORKDIR}/ -type d -name 'font-arial-*')
	do
		cp -Rd ${x} ${D}/usr/share/mplayer/fonts
	done
	# Fix the font symlink ...
	#rm -rf ${D}/usr/share/mplayer/font
	#dosym fonts/font-arial-14-iso-8859-1 /usr/share/mplayer/font

	insinto /etc
	newins ${S}/etc/example.conf mplayer.conf
	dosed -e 's/include =/#include =/' /etc/mplayer.conf
	dosed -e 's/fs=yes/fs=no/' /etc/mplayer.conf
	dosym ../../../etc/mplayer.conf /usr/share/mplayer/mplayer.conf

	#mv the midentify script to /usr/bin for emovix.
	cp ${D}/usr/share/doc/${PF}/TOOLS/midentify ${D}/usr/bin
	chmod a+x ${D}/usr/bin/midentify

	insinto /usr/share/mplayer
	doins ${S}/etc/codecs.conf
	doins ${S}/etc/input.conf
	doins ${S}/etc/menu.conf
}

pkg_preinst() {

	if [ -d "${ROOT}${SKINDIR}default" ]
	then
		rm -rf ${ROOT}${SKINDIR}default
	fi
}

pkg_postinst() {

	if use matrox; then
		depmod -a &>/dev/null || :
	fi

	if use alsa ; then
		einfo "For those using alsa, please note the ao driver name is no longer"
		einfo "alsa9x or alsa1x.  It is now just 'alsa' (omit quotes)."
		einfo "The syntax for optional drivers has also changed.  For example"
		einfo "if you use a dmix driver called 'dmixer,' use"
		einfo "ao=alsa:device=dmixer instead of ao=alsa:dmixer"
		einfo "Some users may not need to specify the extra driver with the ao="
		einfo "command."
	fi
}

pkg_postrm() {

	# Cleanup stale symlinks
	if [ -L ${ROOT}/usr/share/mplayer/font -a \
	     ! -e ${ROOT}/usr/share/mplayer/font ]
	then
		rm -f ${ROOT}/usr/share/mplayer/font
	fi

	if [ -L ${ROOT}/usr/share/mplayer/subfont.ttf -a \
	     ! -e ${ROOT}/usr/share/mplayer/subfont.ttf ]
	then
		rm -f ${ROOT}/usr/share/mplayer/subfont.ttf
	fi
}

