# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit font git-r3

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="http://www.google.com/get/noto"
EGIT_REPO_URI="https://code.google.com/p/noto"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk"

DEPEND=""
RDEPEND="${DEPEND}"

FONT_SUFFIX="$(usex cjk otf '') ttf ttc"

src_prepare() {
	mv fonts/individual/hinted/Noto*.tt[fc] .
	use cjk && mv third_party/noto_cjk/NotoSansCJK* .
	rm -f Makefile
}