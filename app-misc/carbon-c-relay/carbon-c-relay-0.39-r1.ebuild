# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/carbon-c-relay/carbon-c-relay-0.39-r1.ebuild,v 1.2 2015/05/15 13:32:18 grobian Exp $

EAPI=5

inherit toolchain-funcs user

DESCRIPTION="Enhanced C version of Carbon relay, aggregator and rewriter"
HOMEPAGE="https://github.com/grobian/carbon-c-relay"
SRC_URI="https://github.com/grobian/carbon-c-relay/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-libs/openssl"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

pkg_preinst() {
	enewgroup carbon
	enewuser carbon -1 -1 -1 carbon
}

src_prepare() {
	tc-export CC
}

src_install() {
	newbin relay ${PN}
	dodoc README.md

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
