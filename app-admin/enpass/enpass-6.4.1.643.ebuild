
# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg-utils

DESCRIPTION="A cross-platform, complete password management solution."
HOMEPAGE="https://www.enpass.io"
SRC_URI="https://apt.enpass.io/pool/main/e/${PN}/${PN}_${PV}_amd64.deb"

LICENSE="SINEW-EULA"
SLOT="0"
KEYWORDS="~amd64"

# Distribution is restricted by the legal notice
RESRICT="mirror"

DEPEND=""
RDEPEND="
	app-arch/bzip2
	app-arch/lz4
	app-arch/zstd
	app-crypt/gnupg[ldap]
	dev-libs/glib:2
	dev-libs/libbsd
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/harfbuzz
	media-libs/mesa
	media-sound/pulseaudio[asyncns,caps,dbus,tcpd]
	media-video/ffmpeg
	net-libs/gnutls
	net-misc/curl[http2]
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gtk+:3[cups]
	x11-libs/libxkbcommon
	x11-libs/libXScrnSaver
	sys-process/lsof"
BDEPEND=""

S="${WORKDIR}"

PATCHES=(
    "${FILESDIR}/enpass-desktopfile.patch"
)

src_install() {
	exeinto /usr/bin
	exeopts -m0755
	doexe "${FILESDIR}"/enpass

	insinto /opt/enpass
	doins -r "${S}"/opt/enpass/*
	fperms +x /opt/enpass/{Enpass,importer_enpass}

#	dosym ../..opt/enpass/Enpass /usr/bin/enpass
#	fperms +x /usr/bin/enpass

	insinto /usr/share
	doins -r "${S}"/usr/share/{applications,doc,icons,mime}
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
