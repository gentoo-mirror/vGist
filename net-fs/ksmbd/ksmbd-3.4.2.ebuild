# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/cifsd-team/ksmbd.git"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc64 ~riscv ~s390 ~x86"
	SRC_URI="https://github.com/cifsd-team/ksmbd/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="ksmbd kernel server(SMB/CIFS server)"
HOMEPAGE="https://github.com/cifsd-team/ksmbd"
RESTRICT="mirror test"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

MODULE_NAMES="ksmbd(fs/ksmbd)"
BUILD_TARGETS="all"
KV_OBJ="ko"

pkg_setup() {
	if kernel_is -lt 5 4 0; then
		eerror
		eerror "${PN} only supports kernel >= 5.4.0"
		eerror
		die "Upgrade to kernel >= 5.4.0 before installing ksmbd"
	fi
	CONFIG_CHECK="!CONFIG_SMB_SERVER"
	check_extra_config
}