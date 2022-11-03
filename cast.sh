#!/bin/sh
set -o errexit nounset pipefail
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi
cd "$(dirname "$0")"

echo "Incanting and Casting…"

if [ ! -x "./bootstrap" ]; then
    echo "./bootstrap script not found! Are You in the project directory?";
    exit;
fi
if [ ! -x "./incant.sh" ]; then
    echo "./incant.sh script not found! Are You in the project directory?";
    exit;
fi
if [ -f "build" ]; then
    echo "File 'build' needs renamed, so we can have a build/ directory.";
    exit;
fi
./incant.sh
guix build -K -f guix.scm bash coreutils guile
guix shell -f guix.scm bash coreutils guile --rebuild-cache --pure -v4 -- guile
echo "Casting Complete. Make any needed changes now."
