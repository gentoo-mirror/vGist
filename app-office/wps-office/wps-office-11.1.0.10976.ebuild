# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg

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

SLOT="0"
RESTRICT="bindist mirror strip" # mirror as explained at bug #547372
LICENSE="WPS-EULA"
IUSE="big-endian systemd"
REQUIRED_USE="mips? ( !big-endian )"

RDEPEND="
	app-arch/bzip2:0
	app-arch/lz4
	app-arch/xz-utils
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libbsd
	dev-libs/libffi
	dev-libs/libgpg-error
	dev-libs/libpcre:3
	dev-qt/qtgui:5
	dev-qt/qtxml:5
	media-libs/flac
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libsndfile
	media-libs/libvorbis
	media-sound/pulseaudio
	net-libs/libasyncns
	net-print/cups
	x11-libs/gtk+:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	sys-libs/zlib:0
	sys-apps/attr
	sys-apps/dbus
	sys-apps/tcp-wrappers
	sys-apps/util-linux
	sys-libs/libcap
	virtual/glu
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"

src_prepare() {
	# non qt4 on gentoo
	#rm "${S}"/opt/kingsoft/wps-office/office6/librpc{et,wpp,wps}api.so || die
	# fix icu >= 71.1
	rm "${S}"/opt/kingsoft/wps-office/office6/libstdc++.so* || die
	# can't open on openrc system
	use systemd || { rm "${S}"/opt/kingsoft/wps-office/office6/libdbus-1.so* || die ; }

	default
}

src_install() {
	exeinto /usr/bin
	exeopts -m0755
	doexe "${S}"/usr/bin/*

	insinto /usr/share
	doins -r "${S}"/usr/share/{applications,desktop-directories,icons,mime,templates}

	insinto /opt/kingsoft/wps-office
	doins -r "${S}"/opt/kingsoft/wps-office/{office6,templates}

	fperms 0755 /opt/kingsoft/wps-office/office6/{et,ksolaunch,parsecloudfiletool,promecefpluginhost,transerr,wpp,wps,wpscloudsvr,wpsd,wpsoffice,wpspdf}
}
