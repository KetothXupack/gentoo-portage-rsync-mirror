# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CPAN-Changes/CPAN-Changes-0.300.0.ebuild,v 1.1 2015/05/02 16:36:04 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=BRICAS
MODULE_VERSION=0.30
inherit perl-module

DESCRIPTION='Read and write Changes files'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Text-Tabs+Wrap
	>=virtual/perl-version-0.790.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do
