# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MULTILIB_COMPAT=( abi_x86_64 )

inherit unpacker desktop multilib-build xdg

DESCRIPTION="UOS weixin"
HOMEPAGE="https://www.chinauos.com/resource/download-professional"

KEYWORDS="-* ~amd64 ~arm64"

SRC_URI="
	amd64? ( https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.qq.weixin/com.tencent.weixin_${PV}_amd64.deb )
	arm64? ( https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.qq.weixin/com.tencent.weixin_${PV}_arm64.deb )"

SLOT="0"
RESTRICT="bindist strip mirror"
LICENSE="MIT"
IUSE="big-endian"
REQUIRED_USE="
	arm64? ( !big-endian )"

RDEPEND="
	app-accessibility/at-spi2-atk[${MULTILIB_USEDEP}]
	app-accessibility/at-spi2-core[${MULTILIB_USEDEP}]
	dev-libs/atk[${MULTILIB_USEDEP}]
	dev-libs/expat[${MULTILIB_USEDEP}]
	dev-libs/glib[${MULTILIB_USEDEP}]
	dev-libs/nspr[${MULTILIB_USEDEP}]
	dev-libs/nss[${MULTILIB_USEDEP}]
	gnome-base/gconf:2[${MULTILIB_USEDEP}]
	media-libs/alsa-lib:0[${MULTILIB_USEDEP}]
	media-libs/fontconfig:1.0[${MULTILIB_USEDEP}]
	media-libs/mesa[${MULTILIB_USEDEP}]
	net-print/cups:0[${MULTILIB_USEDEP}]
	sys-apps/dbus[${MULTILIB_USEDEP}]
	x11-libs/cairo:0[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:2[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite[${MULTILIB_USEDEP}]
	x11-libs/libXdamage[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence[${MULTILIB_USEDEP}]
	x11-libs/pango[${MULTILIB_USEDEP}]
	sys-apps/lsb-release
	sys-apps/bubblewrap
"

S="${WORKDIR}"

QA_PREBUILT="*"

src_prepare() {
	default

	sed -i 's,Name=微信,Name=wexin-uos,' \
		"${S}/usr/share/applications/weixin.desktop" || die
	sed -i 's,/opt/apps/com.tencent.weixin/files/weixin/weixin,/usr/bin/weixin-uos,' \
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
	fperms +x /opt/weixin-uos/weixin

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
