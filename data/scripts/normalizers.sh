#!/bin/sh

cat $1 | awk '{print $4}' |  sort | uniq -c | sort -nr
