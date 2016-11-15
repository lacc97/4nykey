# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
S="${WORKDIR}/${PN}-fonts-${PV%.*}"
inherit font-r1 unpacker

DESCRIPTION="A futuristic font with focus on legibility"
HOMEPAGE="http://openfontlibrary.org/en/font/xolonium"
SRC_URI="38b086e531b4f1562471bbcec9ff61c9"
SRC_URI="
http://openfontlibrary.org/assets/downloads/${PN}/${SRC_URI}/${PN}.zip
-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	$(unpacker_src_uri_depends)
"
FONT_S=( otf ttf )