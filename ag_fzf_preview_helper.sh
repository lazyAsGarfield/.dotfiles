#!/bin/bash

line_num=$(cut -f2 -d: <<< $1)

lines=27
if [[ -n $2 ]]; then
  lines=$2
fi
lines_2=$((lines/2))

true_beg=$((line_num - lines_2))
beg=$((true_beg > 0 ? true_beg : 1))
end=$((beg + lines))
head=$((end - beg + 1))

rel_line_num=$((true_beg + lines_2 - beg + 1))

file=$(cut -f1 -d: <<< $1)

tail -n+$beg $file | head -n$((head)) | $_awk "{ if (NR == $rel_line_num) "'{printf "%c[1;34m%s\n%c[0m", 27, $0, 27;} else {print;} }'
