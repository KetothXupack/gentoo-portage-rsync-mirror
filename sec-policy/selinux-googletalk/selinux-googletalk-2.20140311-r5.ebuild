# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-googletalk/selinux-googletalk-2.20140311-r5.ebuild,v 1.2 2014/08/22 17:40:01 swift Exp $
EAPI="5"

IUSE="alsa"
MODS="googletalk"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for googletalk"

KEYWORDS="amd64 x86"
