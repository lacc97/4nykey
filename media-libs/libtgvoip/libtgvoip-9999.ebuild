# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/telegramdesktop/${PN}.git"
	EGIT_BRANCH="tdesktop"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="303dcac"
	SRC_URI="
		mirror://githubcl/telegramdesktop/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="VoIP library for Telegram clients"
HOMEPAGE="https://github.com/telegramdesktop/${PN}"

LICENSE="Unlicense"
SLOT="0"
IUSE="alsa pulseaudio static-libs"
REQUIRED_USE="|| ( alsa pulseaudio )"

RDEPEND="
	media-libs/opus
	dev-libs/openssl:*
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	eautoreconf
	sed \
		-e "s:@PREFIX@:${EPREFIX}:" \
		-e "s:@LIBDIR@:$(get_libdir):" \
		-e "s:@PN@:${PN}:" \
		-e "s:@DESC@:${DESCRIPTION}:" \
		-e "s:@PV@:${PV%_p*}:" \
		"${FILESDIR}"/${PN}.pc > ${PN}.pc
}

src_configure() {
	local myeconfargs=(
		$(use_with alsa)
		$(use_with pulseaudio pulse)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
	find "${ED}" -name '*.la' -delete
}
