#!/usr/bin/env bash

mkdir -p /mnt/test{1..2} && \
time_without_nice=`for i in $(seq 1 100500); do echo testing >> /mnt/test1/${i}.log; done & PIDNOTNICE=$!`
time_with_nice=`for i in $(seq 1 100500); do time nice -n 19 ionice -c2 -n7 echo testing >> /mnt/test2/${i}.log; done & PIDNICE=$!`

wait $PIDNOTNICE
wait $PIDNICE

echo time_without_nice=${time_without_nice}
echo time_with_nice=${time_with_nice}

# for quick cleaning
# perl -e 'unlink for ( <*> )'