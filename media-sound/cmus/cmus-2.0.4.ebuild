# Copyright 1999-2005 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="CMus - ncurses based music player."
HOMEPAGE="http://onion.dynserv.net/~timo/cmus.html"
SRC_URI="
	http://mirror.greaterscope.net/cmus/${P}.tar.bz2
	http://onion.dynserv.net/~timo/files/${P}.tar.bz2
"
RESTRICT="primaryuri"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
IUSE="alsa arts flac oss mad modplug vorbis musepack ao"

RDEPEND="
	sys-libs/ncurses
	alsa? ( >=media-libs/alsa-lib-0.9.0 )
	arts? ( kde-base/arts )
	ao? ( media-libs/libao )
	flac? ( >=media-libs/flac-1.1.1 )
	mad? ( >=media-libs/libmad-0.14 )
	modplug? ( >=media-libs/libmodplug-0.7 )
	vorbis? ( >=media-libs/libvorbis-1.0 )
	musepack? ( media-libs/libmpcdec )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
"

pkg_setup() {
	if ! built_with_use sys-libs/ncurses unicode
	then
		eerror "You need sys-libs/ncurses compiled with the unicode USE flag."
		die "need sys-libs/ncurses with unicode support"
	fi
}

teh_conf() {
	local arg="${2:-$1}"
	arg=$(echo config_$arg | tr [:lower:] [:upper:])
	use $1 && arg="$arg=y" || arg="$arg=n"
	myconf="${myconf} $arg"
}

src_compile() {
	local myconf
	teh_conf flac
	teh_conf mad
	teh_conf modplug
	teh_conf musepack mpc
	teh_conf vorbis
	teh_conf alsa
	teh_conf ao
	teh_conf arts
	teh_conf oss

	./configure \
		prefix=/usr \
		${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	rm -rf ${D}usr/share/doc
	dodoc AUTHORS HACKING README cmus-status-display
}
