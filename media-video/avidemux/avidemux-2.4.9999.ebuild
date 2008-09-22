# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/avidemux/avidemux-2.0.38_rc2-r1.ebuild,v 1.1 2005/04/18 15:44:32 flameeyes Exp $

EAPI="1"

inherit subversion flag-o-matic qt4 cmake-utils

WANT_AUTOMAKE="1.9"
DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
ESVN_REPO_URI="svn://svn.berlios.de/avidemux/branches/avidemux_2.4_branch"
ESVN_PATCHES="${P}-*.diff"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE="
	a52 aac alsa arts esd mmx nls png vorbis sdl truetype xvid xv oss x264
	dts qt4 fontconfig lame faac aften gtk jack debug libsamplerate amrnb
	verbose-build
"

RDEPEND="
	>=dev-libs/libxml2-2.6.7
	gtk? ( >=x11-libs/gtk+-2.6.0 )
	>=dev-lang/spidermonkey-1.5-r2
	a52? ( >=media-libs/a52dec-0.7.4 )
	aften? ( >=media-libs/aften-0.0.7 )
	aac? ( >=media-libs/faad2-2.0-r2 )
	faac? ( >=media-libs/faac-1.23.5 )
	mad? ( media-libs/libmad )
	lame? ( >=media-sound/lame-3.93 )
	xvid? ( >=media-libs/xvid-1.0.0 )
	nls? ( >=sys-devel/gettext-0.12.1 )
	vorbis? ( >=media-libs/libvorbis-1.0.1 )
	arts? ( >=kde-base/arts-1.2.3 )
	truetype? ( >=media-libs/freetype-2.1.5 )
	alsa? ( >=media-libs/alsa-lib-1.0.3b-r2 )
	x264? ( media-libs/x264 )
	png? ( media-libs/libpng )
	esd? ( media-sound/esound )
	dts? ( media-libs/libdca )
	sdl? ( media-libs/libsdl )
	xv? ( x11-libs/libXv )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	qt4? ( x11-libs/qt:4 )
	fontconfig? ( media-libs/fontconfig )
	jack? ( media-sound/jack-audio-connection-kit )
	libsamplerate? ( media-libs/libsamplerate )
	amrnb? ( media-libs/amrnb )
"
DEPEND="
	$RDEPEND
	oss? ( virtual/os-headers )
	x86? ( dev-lang/nasm )
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
"

pick() {
	if ! use $1; then
		local CMAKE_VAR="$(echo ${2:-${1}} | tr [:lower:] [:upper:])"
		mycmakeargs="-DNO_${CMAKE_VAR}=1 ${mycmakeargs}"
	fi
}

pkg_setup() {
	filter-flags \
		-fno-default-inline -funroll-loops -funroll-all-loops -fforce-addr
	use verbose-build && CMAKE_COMPILER_VERBOSE=y
}

src_compile() {
	# provide svn revision
	[[ -z ${ESVN_WC_REVISION} ]] && subversion_wc_info
	local mycmakeargs="
		-DNO_SVN=1 \
		-DSubversion_FOUND=1 \
		-DProject_WC_REVISION=${ESVN_WC_REVISION}
	"

	for x in \
		gtk qt4 nls sdl arts alsa esd jack oss libsamplerate lame faac aften \
		amrnb vorbis xvid x264 fontconfig
	do
		pick $x
	done
	pick dts libdca
	pick aac faad
	pick xv xvideo
	pick png libpng
	pick truetype freetype

	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS
}
