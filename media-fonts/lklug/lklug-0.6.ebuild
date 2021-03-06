# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/lklug/lklug-0.6.ebuild,v 1.6 2015/05/21 08:47:46 chewi Exp $

EAPI="4"

inherit font

MY_P="ttf-sinhala-${P}"
DESCRIPTION="Sinhala font"
HOMEPAGE="http://sinhala.sourceforge.net"
SRC_URI="http://sinhala.sourceforge.net/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~ppc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"
FONT_S="${S}"

FONT_SUFFIX="ttf"

DOCS="README.fonts"
