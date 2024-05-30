# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

# git.foss21.org is the official repository per upstream
DESCRIPTION="A strong libtool implementation, written in C"
HOMEPAGE="https://git.foss21.org/slibtool"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.foss21.org/slibtool"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/midipix.asc
	inherit verify-sig

	SRC_URI="https://dl.midipix.org/slibtool/${P}.tar.xz"
	SRC_URI+=" verify-sig? ( https://dl.midipix.org/slibtool/${P}.tar.xz.sig )"

	KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc ~x86 ~x64-macos"
fi

BDEPEND="sys-devel/m4"

if [[ ${PV} != *9999 ]] ; then
	BDEPEND+=" verify-sig? ( >=sec-keys/openpgp-keys-midipix-20240315 )"
fi

LICENSE="MIT"
SLOT="0"

src_configure() {
	# Custom configure script (not generated by autoconf)
	./configure \
		--compiler="$(tc-getCC)" \
		--host=${CHOST} \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
			|| die
}
