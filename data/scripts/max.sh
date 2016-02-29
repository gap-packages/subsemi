#!/bin/sh

# inputs: a semigroup database file, a column tag
# output: the maximum value in the column referred by the tag

cat $1 | awk '{print $2}' | grep -o "$2[0-9]*" |  tr -d '[[:alpha:]]' | awk '{print $1+0}' | sort -nu | tail -1
