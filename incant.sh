#!/bin/sh

echo "Beginning Incantation…"

if [ ! -x "./bootstrap" ]; then
    echo "./bootstrap script not found! Are You in the project directory?";
    exit;
fi
if [ -f "build" ]; then
    echo "File 'build' needs renamed, so we can have a build/ directory.";
    exit;
fi
rm -rfv build/
mkdir -pv build/
./bootstrap
cd build/
../configure
make
DESTDIR=test/ make install
tree test
make dist
mv -vt .. *.bz2
echo "Incantation Complete."
