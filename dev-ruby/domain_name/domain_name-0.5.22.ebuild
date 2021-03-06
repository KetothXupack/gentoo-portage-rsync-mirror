# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/domain_name/domain_name-0.5.22.ebuild,v 1.4 2015/03/11 16:46:56 ago Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Domain Name manipulation library for Ruby"
HOMEPAGE="https://github.com/knu/ruby-domain_name"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/unf-0.0.5-r1:0"

ruby_add_bdepend "
	test? (
		>=dev-ruby/test-unit-2.5.5
		dev-ruby/shoulda
	)"

all_ruby_prepare() {
	sed -i -e '/bundler/,/end/ d; i gem "unf"' test/helper.rb || die
	rm Gemfile* || die

	# Remove development dependencies
	sed -i -e '/dependency.*\(shoulda\|bundler\|jeweler\|rdoc\)/d' \
		${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid dependency on git.
	sed -i -e 's/`git ls-files`/""/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib:test test/test_*.rb
}
