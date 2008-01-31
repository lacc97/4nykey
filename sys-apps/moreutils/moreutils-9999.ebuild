# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="A collection of unix tools that nobody thought to write 30 years ago"
HOMEPAGE="http://www.kitenet.net/~joey/code/moreutils.html"
ESVN_REPO_URI="svn://svn.debian.org/moreutils/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND="
	dev-lang/perl
"
DEPEND="
	${RDEPEND}
	doc? (
		=app-text/docbook-xml-dtd-4.4*
		app-text/docbook2X
	)
"

src_unpack() {
	subversion_src_unpack
	sed -i *.docbook \
		-e 's#file://.*4\.4#file:///usr/share/sgml/docbook/xml-dtd-4.4#'
	use doc || sed -i Makefile -e '/man1/d; s:$(MANS)::'
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	emake PREFIX="${D}" INSTALL_BIN=install install || die "emake install failed"
	dodoc README
}