#!/usr/bin/env bash

mkdir -p dist

for i in $(seq 3)
do
    NAME=georam-patch-$i
    vasm6502_oldstyle -cbm-prg -Fbin -chklabels -nocase -dotdir \
                      src/$NAME.asm -o dist/$NAME.prg -L dist/$NAME.lst
done
