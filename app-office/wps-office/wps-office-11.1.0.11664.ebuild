# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font unpacker xdg

MY_PV="$(ver_cut 4)"

DESCRIPTION="WPS Office is an office productivity suite, Here is the Chinese version"
HOMEPAGE="http://www.wps.cn/product/wpslinux/ http://wps-community.org/"

KEYWORDS="amd64 ~arm64 ~loong ~mips"

SRC_URI="
	amd64?	( https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/${MY_PV}/${PN}_${PV}_amd64.deb )
	arm64?	( https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/${MY_PV}/${PN}_${PV}_arm64.deb )
	loong?	( https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/${MY_PV}/${PN}_${PV}_loongarch64.deb )
	mips?	( https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/${MY_PV}/${PN}_${PV}_mips64el.deb )
"

SLOT="0/${MY_PV}"
RESTRICT="bindist mirror strip"
LICENSE="WPS-EULA"
IUSE="big-endian"
REQUIRED_USE="mips? ( !big-endian )"

RDEPEND="
	app-arch/bzip2
	dev-libs/glib:2
	media-libs/fontconfig:1.0
	media-libs/flac
	media-libs/libvorbis
	media-sound/pulseaudio
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
	exeinto /usr/bin
	exeopts -m0755
	doexe "${S}"/usr/bin/*

	insinto /usr/share
	doins -r "${S}"/usr/share/{applications,desktop-directories,fonts,icons,mime,templates}

	insinto "/opt/kingsoft/${PN}"
	doins -r "${S}"/opt/kingsoft/${PN}/{office6,templates}

	fperms 0755 /opt/kingsoft/${PN}/office6/{et,ksolaunch,promecefpluginhost,transerr,wpp,wps,wpscloudsvr,wpsd,wpsoffice,wpspdf}
}
