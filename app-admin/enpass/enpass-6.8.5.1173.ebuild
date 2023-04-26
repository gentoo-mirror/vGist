# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="A cross-platform, complete password management solution."
HOMEPAGE="https://www.enpass.io"
SRC_URI="https://apt.enpass.io/pool/main/e/${PN}/${PN}_${PV}_amd64.deb"

LICENSE="SINEW-EULA"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RESRICT="bindist mirror"

# Dependencies
#
# objdump -p ./Enpass | grep NEEDED | awk '{print $2}' | xargs equery b | sort | uniq

RDEPEND="
	app-arch/xz-utils
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libglvnd
	media-sound/pulseaudio
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/zlib
	x11-libs/gtk+:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango"

QA_PREBUILT="
	opt/enpass/Enpass
	opt/enpass/importer_enpass
	opt/enpass/wifisyncserver_bin
"

S="${WORKDIR}"

src_prepare() {
	default
	gzip -d usr/share/doc/enpass/changelog.gz || die
}

src_install() {
	domenu usr/share/applications/enpass.desktop
	dodoc usr/share/doc/enpass/changelog

	insinto /opt/enpass
	doins -r opt/enpass/.
	fperms +x /opt/enpass/{Enpass,importer_enpass,wifisyncserver_bin}

	insinto /usr/share/mime/packages
	doins usr/share/mime/packages/application-enpass.xml

	local size
	for size in 16 22 24 32 48 ; do
		doicon -c status -s ${size} usr/share/icons/hicolor/${size}x${size}/status/enpass-status.png
		doicon -c status -s ${size} usr/share/icons/hicolor/${size}x${size}/status/enpass-status-dark.png
	done

	for size in 16 24 32 48 64 96 128 256; do
		doicon -s ${size} usr/share/icons/hicolor/${size}x${size}/apps/enpass.png
	done
}
