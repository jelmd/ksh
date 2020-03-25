#!/bin/ksh93

[[ -n $1 ]] && cd "$1"
[[ ! -x bin/package ]] && print -u2 'bin/package not found.' && exit 1

HOSTTYPE=${ bin/package; }
bin/package write tgz source INIT ast-ksh
bin/package write lcl source INIT ast-ksh
mkdir tmp.$$
cd tmp.$$ || exit 1

V=( $(<../lib/package/ast-ksh.ver) )
V=${V[1]}
gunzip -c ../lib/package/lcl/ast-ksh.*.tgz >ast-ksh.tar
gunzip -c ../lib/package/tgz/ast-ksh.*.tgz| tar xf - README lib
rm -f lib/package/ksh.{req,ver}
SED=${ whence gsed ; }
[[ -z ${SED} ]] && SED=sed
print '/^<BODY / s/Y.*/Y link="slateblue" vlink="teal" >/
/^<STYLE / a\H3 { color: red; } \
	BODY { background: white; } \
	#comp { background: papayawhip; padding: 1ex; }
/^<TABLE align/ s/bordercolor=[^ ]*/id="comp"/
'		>.html.sed
${SED} -i -f .html.sed lib/package/ast-ksh.html
tar uf ast-ksh.tar README lib
gzip -c9 ast-ksh.tar >../ast-ksh.${V}.tgz
xz -zc9 ast-ksh.tar >../ast-ksh.${V}.txz
rm -rf *

V=( $(<../lib/package/INIT.ver) )
V=${V[1]}
gunzip -c ../lib/package/lcl/INIT.*.tgz	>INIT.tar
gunzip -c ../lib/package/tgz/INIT.*.tgz | \
	tar xf - README bin lib src/lib src/{,cmd/}{Makefile,Mamfile}
${SED} -i -f .html.sed lib/package/INIT.html
tar uf INIT.tar README lib src bin
#gzip -c9 INIT.tar >../INIT.${V}.tgz
xz -zc9 INIT.tar >../INIT.${V}.txz

cd -
rm -rf tmp.$$
