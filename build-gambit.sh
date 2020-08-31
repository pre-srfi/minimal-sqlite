#!/bin/sh
set -eu
cd "$(dirname "$0")"
echo "Entering directory '$PWD'"
set -x
gsc-script -exe . minimal-sqlite.sld test.scm -o test
