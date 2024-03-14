# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="WPS Office is an office productivity suite, Here is the Chinese version"
HOMEPAGE="http://www.wps.cn/product/wpslinux/"

KEYWORDS="~amd64 ~arm64 ~mips"

SRC_URI="
	amd64?	( https://wb9.s-ton.top/wps302/${PV}/amd64 -> ${PN}_${PV}_amd64.deb )
	arm64?	( https://wb9.s-ton.top/wps302/${PV}/arm64 -> ${PN}_${PV}_arm64.deb )
	loong?	( https://wb9.s-ton.top/wps302/${PV}/loongarch64 -> ${PN}_${PV}_loongarch64.deb )
	mips?	( https://wb9.s-ton.top/wps302/${PV}/mips64el -> ${PN}_${PV}_mips64el.deb )
"

SLOT="0"
RESTRICT="bindist mirror strip"
LICENSE="WPS-EULA"
IUSE="big-endian"
REQUIRED_USE="mips? ( !big-endian )"

RDEPEND="
	app-arch/bzip2
	dev-libs/glib:2
	media-libs/fontconfig:1.0
	|| ( media-libs/flac media-libs/flac-compat:8.3.0 )
	media-libs/libpulse
	media-libs/libvorbis
	media-libs/tiff-compat:4
	net-libs/libasyncns
	net-print/cups
	sys-apps/tcp-wrappers
	sys-libs/libcap
	x11-libs/gtk+:2
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	virtual/glu
"

S="${WORKDIR}"

src_install() {
	insinto /etc/xdg/menus/
	doins "${S}"/etc/xdg/menus/applications-merged/wps-office.menu

	exeinto /usr/bin
	exeopts -m0755
	doexe "${S}"/usr/bin/*

	insinto /usr/share
	doins -r "${S}"/usr/share/{applications,desktop-directories,icons,mime,templates}

	insinto /opt/kingsoft/"${PN}"
	rm "${S}"/opt/kingsoft/wps-office/office6/libstdc++.so* || die
	doins -r "${S}"/opt/kingsoft/"${PN}"/{office6,templates}

	fperms 0755 /opt/kingsoft/"${PN}"/office6/{et,ksolaunch,promecefpluginhost,transerr,wpp,wps,wpscloudsvr,wpsd,wpsoffice,wpspdf}
}
