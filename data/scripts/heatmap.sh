#!/bin/sh

# hardcoded size vs. D-classes, TODO make it general

cat $1 | awk '{print $2}' \
       | awk -F '_' '{print $4" "$1}' \
       | tr -d '[[:alpha:]]' \
       | awk \
           'BEGIN {
                    maxx=0;
                    maxy=0
                  }

                  {
                    x=$1+0;
                    y=$2+0;
                    if (x>maxx){maxx=x};
                    if (y>maxy){maxy=y};
                    v[x,y]++;
                  }

            END {
                  for (x=0;x<=maxx;x++)
                  {
                    for (y=0;y<=maxy;y++)
                    {
                      printf "%d ", v[x,y]+0
                    }
                    print ""
                  }
                }'
