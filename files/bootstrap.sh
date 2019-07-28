#/bin/bash

set -e

cd

if [[ -e $HOME/.bootstrapped ]]; then
  exit 0
fi

PYPY_VERSION=7.1.1
PYPY2_FILENAME="pypy2.7-v${PYPY_VERSION}-linux64"

if [[ -e $HOME/$PYPY2_FILENAME.tar.bz2 ]]; then
  tar -xjf $HOME/$PYPY2_FILENAME.tar.bz2
  rm -rf $HOME/$PYPY2_FILENAME.tar.bz2
else
  wget -O - https://bitbucket.org/pypy/pypy/downloads/$PYPY2_FILENAME.tar.bz2 |tar -xjf -
fi

mv -n $PYPY2_FILENAME pypy

## library fixup
mkdir -p pypy/lib
[ -f /lib64/libncurses.so.5.9 ] && ln -snf /lib64/libncurses.so.5.9 $HOME/pypy/lib/libtinfo.so.5
[ -f /lib64/libncurses.so.6.1 ] && ln -snf /lib64/libncurses.so.6.1 $HOME/pypy/lib/libtinfo.so.5

mkdir -p $HOME/bin

cat > $HOME/bin/python <<EOF
#!/bin/bash
LD_LIBRARY_PATH=$HOME/pypy/lib:$LD_LIBRARY_PATH exec $HOME/pypy/bin/pypy "\$@"
EOF

chmod +x $HOME/bin/python
$HOME/bin/python --version

touch $HOME/.bootstrapped
