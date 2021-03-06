# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Audio-Wav/Audio-Wav-0.140.0.ebuild,v 1.1 2015/04/12 19:06:05 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=BRIANSKI
MODULE_VERSION=0.14
inherit perl-module

DESCRIPTION="Modules for reading & writing Microsoft WAV files"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""

RDEPEND="
	|| ( <dev-perl/Inline-0.790.0 ( >=dev-perl/Inline-0.790.0 dev-perl/Inline-C ) )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST=do
