#!/bin/bash -x
set -o errexit

[ $(sqlite3 db.sqlite "select count(*) from fig2") -eq $(find -L fig2*/ -name "*.out" | wc -l) ]
[ $(sqlite3 db.sqlite "select count(*) from fig3") -eq $(find -L fig3*/ -name "*.out" | wc -l) ]
