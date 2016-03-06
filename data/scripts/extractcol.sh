#!/bin/sh

# extracting a column by a tag

cat $1 | awk '{print $2}' | grep -o "$2[0-9][0-9]*" | tr -d '[[:alpha:]_]'  |  awk '{print $1+0}'
