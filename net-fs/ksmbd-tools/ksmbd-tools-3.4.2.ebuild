# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="cifsd kernel server userspace utilities"
HOMEPAGE="https://github.com/cifsd-team/ksmbd-tools"
SRC_URI="https://github.com/cifsd-team/ksmbd-tools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="kerberos"

DEPEND=">=dev-libs/glib-2.40
	>=dev-libs/libnl-3.0
	kerberos? ( virtual/krb5 )"
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=( AUTHORS README Documentation/configuration.txt )

src_prepare() {
	default
	eautoreconf
}

src_configure(){
	econf $(use_enable kerberos krb5)
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc/ksmbd
	doins "${S}"/smb.conf.example

	systemd_dounit "${FILESDIR}"/ksmbd.service
}
