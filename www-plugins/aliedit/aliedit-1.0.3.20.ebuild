# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit nsplugins

DESCRIPTION="Alipay Secure Edit Component"
SRC_URI="https://download.alipay.com/alipaysc/linux/${PN}/${PV}/${PN}.tar.gz"
HOMEPAGE="http://www.alipay.com/"
IUSE=""
SLOT="0"

KEYWORDS="~amd64 ~x86"
LICENSE="Alipay"
RESTRICT="strip mirror"

RDEPEND="media-libs/libpng:1.2
	x11-libs/gtk+:2"

src_compile() {
	ARCHIVE=`awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' ./aliedit.sh`
	tail -n+$ARCHIVE aliedit.sh | tar xzvm -C ./ \
	|| die "Can't get archive files"
}

src_install() {
	insinto "/opt/netscape/plugins"
	if use amd64; then
		doins "${WORKDIR}"/lib/libaliedit64.so
		inst_plugin /opt/netscape/plugins/libaliedit64.so
	else
		doins "${WORKDIR}"/lib/libaliedit32.so
		inst_plugin /opt/netscape/plugins/libaliedit32.so
	fi
}
