#!/usr/bin/env zsh

NUM=256
function one_round() {
OUTPUT=$(./gen-box)
BOXID=(${(s. .)OUTPUT})
echo "Attacking "$BOXID[2]" (Key: "$BOXID[1]")"
gcc -O2 -mavx -mtune=native -march=native -std=c11 enctbox.c template.o -o box
rm trace_mem* trace_stack* *.config *.output *.input *.trace *.tmp* *.info
./trace_it.py $NUM ./box >/dev/null

WB_OUT=$(whitebox_dca/dca-all mem_data*$NUM*.trace mem_data*$NUM*.input $NUM "0x"$BOXID[1])
WB_RES=(${(s. .)WB_OUT})
# 1: best guess
# 2: best bit
# 3: best peak
# 4: correct pos
# 5: correct peak
sqlite3 traces.sqlite 'insert into traces values("'$BOXID[2]'", '$WB_RES[1]', '$WB_RES[3]', '$WB_RES[2]', '$WB_RES[4]', '$WB_RES[5]', 0x'$BOXID[1]');'
rm -f *.input *.trace
}

rm *.bin *.info *.output *.config *.tmp*
while true; do one_round; done
