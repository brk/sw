#!/bin/bash

GMPSRCROOT=~/gmp
GMPINSTALL=$GMPSRCROOT/install
GMPURL=ftp://ftp.gnu.org/gnu/gmp
GMPVERSION=4.2.4
GMPSRCDIR=$GMPSRCROOT/gmp-$GMPVERSION
GMPARCHIVE=gmp-$GMPVERSION.tar.bz2
GMPGET=wget
GMPUNWRAP="tar -xjf"

CVC3SRCROOT=~/cvc3
CVC3SRCDIR=$CVC3SRCROOT/svn
CVC3INSTALL=$CVC3SRCROOT/install

echo "Creating directories..."
for d in $GMPSRCROOT $CVC3SRCROOT; do
  mkdir -p $d
done

pushd $GMPSRCROOT
  if [ ! -f $GMPARCHIVE ]; then
    echo "Downloading and unwrapping GMP..."
    $GMPGET $GMPURL/$GMPARCHIVE
  fi

  if [ ! -d $GMPSRCDIR ]; then
    $GMPUNWRAP $GMPARCHIVE
  fi

  if [ ! -d $GMPINSTALL ]; then
    mkdir $GMPINSTALL
  fi

  if [ ! -f $GMPSRCDIR/gmp.h ]; then
    pushd $GMPSRCDIR
      echo "Configuring GMP to install to $GMPINSTALL"
      # using ABI = 64 by default...
      # means that CVC3 must be compiled same way
      # http://gmplib.org/manual/ABI-and-ISA.html
      # can inspect GMP_LIMB_BITS to see if ABI=32 or 64
      ./configure --prefix="$GMPINSTALL"

      echo "Next step is running 'make', 'make check',"
      echo "and 'make install' for GMP. This will take a few minutes!"
      make && make check && make install
    popd
  fi

  pushd $GMPSRCDIR
    GMPABI=`grep -m 1 '#define GMP_LIMB_BITS' gmp.h | awk '{print $3}'`
    echo "gmp abi is $GMPABI"
    GMPCFLAGS=`grep "CFLAGS='" config.log | sort | head -n 1 | perl -e '$_ = <>; s/CFLAGS=//; s/^.|.$//g; print;'`
    echo "GMP CFLAGS = $GMPCFLAGS"
  popd
popd

#----------------------------------------------------------------------
#If you ever happen to want to link against installed libraries
#in a given directory, LIBDIR, you must either use libtool, and
#specify the full pathname of the library, or use the `-LLIBDIR'
#flag during linking and do at least one of the following:
#   - add LIBDIR to the `DYLD_LIBRARY_PATH' environment variable
#     during execution
#
#See any operating system documentation about shared libraries for
#more information, such as the ld(1) and ld.so(8) manual pages.
#----------------------------------------------------------------------

if [ ! -d $CVC3SRCDIR ]; then
  echo "CVC3 source dir '$CVC3SRCDIR' does not exist!"
else
  if [ -d $CVC3INSTALL ]; then
    echo "CVC3 already installed in '$CVC3INSTALL';"
    echo "Remove it and re-run the script to rebuild CVC3"
  else
    mkdir $CVC3INSTALL
    pushd $CVC3SRCDIR
      ./configure --prefix="$CVC3INSTALL" CXXFLAGS="$GMPCFLAGS" \
        --with-extra-libs="$GMPINSTALL/lib"\
        --with-extra-includes="$GMPINSTALL/include"
      make && make install
      pushd test
        make && ./bin/test
      popd # test
    popd
  fi # CVC3INSTALL
fi # CVC3SRCDIR
