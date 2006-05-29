# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="library for decoding DTS Coherent Acoustics streams used in DVD"
HOMEPAGE="http://developers.videolan.org/libdca.html"
ESVN_REPO_URI="svn://svn.videolan.org/${PN}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="oss debug"

DEPEND="!media-libs/libdts"
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	epatch ${FILESDIR}/${P}-*.patch
	eautoreconf
}

src_compile() {
	econf \
		--enable-shared \
		`use_enable oss` \
		`use_enable debug` || die
	emake || die "emake failed"
}

src_install() {
	einstall docdir=${D}/usr/share/doc/${PF}/html || die
	insinto /usr/include
	doins libdts/dts_internal.h # for avidemux-svn
	dodoc AUTHORS ChangeLog NEWS README TODO doc/libdts.txt
}
