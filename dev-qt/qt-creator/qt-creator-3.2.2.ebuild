# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qt-creator/qt-creator-3.2.2.ebuild,v 1.8 2015/05/04 00:09:31 pesa Exp $

EAPI=5

PLOCALES="cs de fr ja pl ru sl uk zh_CN zh_TW"

inherit eutils l10n multilib qmake-utils virtualx

DESCRIPTION="Lightweight IDE for C++/QML development centering around Qt"
HOMEPAGE="http://doc.qt.io/qtcreator/"
LICENSE="|| ( LGPL-2.1 LGPL-3 )"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI=(
		"git://code.qt.io/${PN}/${PN}.git"
		"https://code.qt.io/git/${PN}/${PN}.git"
	)
else
	MY_PV=${PV/_/-}
	MY_P=${PN}-opensource-src-${MY_PV}
	[[ ${MY_PV} == ${PV} ]] && MY_REL=official || MY_REL=development
	SRC_URI="http://download.qt.io/${MY_REL}_releases/${PN/-}/${PV%.*}/${MY_PV}/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
fi

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

QTC_PLUGINS=(android autotools:autotoolsprojectmanager baremetal bazaar
	clang:clangcodemodel clearcase cmake:cmakeprojectmanager cvs git
	ios mercurial perforce python:pythoneditor qnx subversion valgrind)
IUSE="debug doc test webkit ${QTC_PLUGINS[@]%:*}"

# minimum Qt version required
QT_PV="4.8.5:4"

RDEPEND="
	=dev-libs/botan-1.10*[threads]
	>=dev-qt/designer-${QT_PV}
	>=dev-qt/qtcore-${QT_PV}[ssl]
	>=dev-qt/qtdeclarative-${QT_PV}[accessibility]
	>=dev-qt/qtgui-${QT_PV}[accessibility]
	>=dev-qt/qthelp-${QT_PV}[doc?]
	>=dev-qt/qtscript-${QT_PV}
	>=dev-qt/qtsql-${QT_PV}
	>=dev-qt/qtsvg-${QT_PV}[accessibility]
	>=sys-devel/gdb-7.5[client,python]
	clang? ( >=sys-devel/clang-3.2:= )
	webkit? ( >=dev-qt/qtwebkit-${QT_PV} )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( >=dev-qt/qttest-${QT_PV} )
"
PDEPEND="
	autotools? ( sys-devel/autoconf )
	bazaar? ( dev-vcs/bzr )
	cmake? ( dev-util/cmake )
	cvs? ( dev-vcs/cvs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	subversion? ( dev-vcs/subversion )
	valgrind? ( dev-util/valgrind )
"

src_prepare() {
	# disable unwanted plugins
	for plugin in "${QTC_PLUGINS[@]#[+-]}"; do
		if ! use ${plugin%:*}; then
			einfo "Disabling ${plugin%:*} plugin"
			sed -i -re "/(^\s+|SUBDIRS\s*\+=\s*)(${plugin#*:})\>/d" \
				src/plugins/plugins.pro || die "failed to disable ${plugin%:*} plugin"
		fi
	done

	# automagic dep on qtwebkit (bug 538236)
	if ! use webkit; then
		sed -i -e 's/contains(QT_CONFIG, webkit).*$/DEFINES += QT_NO_WEBKIT/' \
			src/plugins/help/help.pro || die "failed to disable webkit"
	fi

	# disable broken or unreliable tests
	sed -i -e '/lexer/d' tests/auto/cplusplus/cplusplus.pro || die
	sed -i -e '/dumpers\.pro/d' tests/auto/debugger/debugger.pro || die
	sed -i -e '/CONFIG -=/ s/$/ testcase/' tests/auto/extensionsystem/pluginmanager/correctplugins1/plugin?/plugin?.pro || die
	sed -i -e '/parsertests\.pro/d' tests/auto/valgrind/memcheck/memcheck.pro || die

	# fix translations
	sed -i -e "/^LANGUAGES =/ s:=.*:= $(l10n_get_locales):" \
		share/qtcreator/translations/translations.pro || die

	# remove bundled qbs
	rm -rf src/shared/qbs || die
}

src_configure() {
	EQMAKE4_EXCLUDE="share/qtcreator/templates/*
			tests/*"
	eqmake4 IDE_LIBRARY_BASENAME="$(get_libdir)" \
		IDE_PACKAGE_MODE=1 \
		LLVM_INSTALL_DIR="${EPREFIX}/usr" \
		$(use test && echo BUILD_TESTS=1) \
		USE_SYSTEM_BOTAN=1
}

src_test() {
	cd tests/auto || die
	VIRTUALX_COMMAND=default virtualmake
}

src_install() {
	emake INSTALL_ROOT="${ED}usr" install

	dodoc dist/{changes-*,known-issues}

	# install documentation
	if use doc; then
		emake docs
		# don't use ${PF} or the doc will not be found
		insinto /usr/share/doc/qtcreator
		doins share/doc/qtcreator/qtcreator{,-dev}.qch
		docompress -x /usr/share/doc/qtcreator/qtcreator{,-dev}.qch
	fi

	# install desktop file
	make_desktop_entry qtcreator 'Qt Creator' QtProject-qtcreator 'Qt;Development;IDE'
}
