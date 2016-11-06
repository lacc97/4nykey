# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/greginvm/${PN}.git"
	REQUIRED_USE="cython"
else
	inherit vcs-snapshot
	SRC_URI="mirror://githubcl/greginvm/${PN}/tar.gz/${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A Cython wrapper for the Clipper library"
HOMEPAGE="https://github.com/greginvm/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="+cython"

RDEPEND="
	cython? ( dev-python/cython[${PYTHON_USEDEP}] )
"
DEPEND+="
	${RDEPEND}
"

src_prepare() {
	default
	if use cython; then
		touch "${S}"/dev
	else
		rm -f "${S}"/dev
	fi
	local _v="${PV%_p*}"
	[[ -z ${PV%%*9999} ]] && _v="$(git describe --tags)"
	sed \
		-e '/setuptools_scm/d' \
		-e "s:use_scm_version=True:version=\"${_v}\":" \
		-i "${S}"/setup.py
}
