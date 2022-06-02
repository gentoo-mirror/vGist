# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker desktop xdg

DESCRIPTION="UOS weixin"
HOMEPAGE="https://www.chinauos.com/resource/download-professional"

KEYWORDS="-* ~amd64 ~arm64"

SRC_URI="
	amd64? ( https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.qq.weixin/com.tencent.weixin_${PV}_amd64.deb )
	arm64? ( https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.qq.weixin/com.tencent.weixin_${PV}_arm64.deb )"

SLOT="0"
RESTRICT="bindist strip mirror"
LICENSE="MIT"

RDEPEND="
	app-accessibility/at-spi2-atk
	app-accessibility/at-spi2-core
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib:0
	media-libs/fontconfig:1.0
	media-libs/mesa
	net-print/cups:0
	sys-apps/dbus
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
	sys-apps/lsb-release
	sys-apps/bubblewrap
"

S="${WORKDIR}"

QA_PREBUILT="*"

src_prepare() {
	default

	sed -i 's,Name=微信,Name=Wexin uos,' \
		"${S}/usr/share/applications/weixin.desktop" || die
	sed -i 's,/opt/apps/com.tencent.weixin/files/weixin/weixin.sh,/usr/bin/weixin-uos,' \
		"${S}/usr/share/applications/weixin.desktop" || die
}

src_install() {
	newmenu "${S}/usr/share/applications/weixin.desktop" weixin-uos.desktop
	dobin "${FILESDIR}/weixin-uos"

	for size in 16 32 48 64 128 256; do
		doicon -s ${size} usr/share/icons/hicolor/${size}x${size}/apps/weixin.png
	done

	insinto /opt/weixin-uos
	doins -r "${S}"/opt/apps/com.tencent.weixin/files/weixin/*

	insinto /opt/weixin-uos/crap
	doins "${FILESDIR}"/uos-{lsb,release}

	insinto /opt/weixin-uos/crap/usr/lib/license
	doins "${S}/usr/lib/license/libuosdevicea.so"
	keepdir /usr/lib/license

	insinto /opt/weixin-uos/crap/var/uos
	newins "${FILESDIR}/license.key" .license.key

	insinto /opt/weixin-uos/crap/var/lib/uos-license
	newins "${FILESDIR}/license.json" .license.json
}