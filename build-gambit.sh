#!/bin/sh
set -eu
cd "$(dirname "$0")"
echo "Entering directory '$PWD'"
set -x
gsc-script -exe -o test . minimal-sqlite.sld test.scm
