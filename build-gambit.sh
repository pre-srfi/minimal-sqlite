#!/bin/sh
set -eu
cd "$(dirname "$0")"
echo "Entering directory '$PWD'"
set -x
rm -f minimal-sqlite.o1
gsc-script -exe -o test -pkg-config sqlite3 minimal-sqlite.scm test.scm
