# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils

DESCRIPTION="A simple command line calendar for Chinese lunar"
HOMEPAGE="http://ccal.chinesebay.com/ccal/ccal.htm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips x86"
IUSE="pdf"
SRC_URI="http://ccal.chinesebay.com/${PN}/${P}.tar.gz"
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}
	pdf? ( app-text/ghostscript-gpl )
	sys-libs/glibc"

src_install() {
	use pdf && ( dobin ccalpdf; doman ccalpdf.1 )
	dobin ccal
	doman ccal.1
}
