# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils

DESCRIPTION="The ccal utility is a simple-to-use command line program which writes a Gregorian calendar together with Chinese calendar to standard output."
HOMEPAGE="http://ccal.chinesebay.com/ccal/ccal.htm"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86 amd64 x86"
IUSE=""
SRC_URI="http://ccal.chinesebay.com/${PN}/${P}.tar.gz"
RESTRICT="mirror"

RDEPEND=""
DEPEND="${DEPEND}
	sys-libs/glibc"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin ccal ccalpdf || die "dobin failed"
	doman ccal.1 ccalpdf.1 || die "doman failed"
}
