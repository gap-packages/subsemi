#!/bin/sh

# input: 2 1-column files encoding X and Y pairs
# output: matrix containing the frequency of the (X,Y) pair in the X,Y position

paste $1 $2 | awk \
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
