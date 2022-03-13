#!/bin/bash -eu

byte=1G
max=1000

export f=$(mktemp)
trap "rm -f $f" EXIT

base64 /dev/random | head -c"$byte" > "$f"

echo ====================================
echo DATA
du -sh "$f"
echo ====================================
grep 'model ' /proc/cpuinfo | sort | uniq
echo Device Model:     PHISON PS3112-S12-256G


export time="/usr/bin/time -f %e"
echo "Rotate Avg $max ...."
##################################################################
v=0
c=0
for i in $(seq $max);do
  echo -en "\r${i}" >&2
  v="$v + $( $time sort -T /tmp/sort $f 2>&1 > /dev/null )"
  c=$(( c + 1 ))
done
v="( $v ) / $c"
a="0$(echo "scale=5; $v" | bc -l)"
echo -e "$a\tsort -T /tmp/sort"
##################################################################
v=0
c=0
for i in $(seq $max);do
  v="$v + $( $time sort -T /dev/shm/sort $f 2>&1 > /dev/null )"
  c=$(( c + 1 ))
done
v="( $v ) / $c"
a="0$(echo "scale=5; $v" | bc -l)"
echo -e "$a\tsort -T /dev/shm/sort"
##################################################################
v=0
c=0
for i in $(seq $max);do
  v="$v + $( $time sort -S512M $f 2>&1 > /dev/null )"
  c=$(( c + 1 ))
done
a="0$(echo "scale=5; $v" | bc -l)"
echo -e "$a\tsort -S 512M"
##################################################################
v=0
c=0
for i in $(seq $max);do
  v="$v + $( $time sort -S512M -T /tmp/sort $f 2>&1 > /dev/null )"
  c=$(( c + 1 ))
done
v="( $v ) / $c"
a="0$(echo "scale=5; $v" | bc -l)"
echo -e "$a\tsort -S512M -T /tmp/sort"
##################################################################
v=0
c=0
for i in $(seq $max);do
  v="$v + $( $time sort -S512M -T /dev/shm/sort $f 2>&1 > /dev/null )"
  c=$(( c + 1 ))
done
v="( $v ) / $c"
a="0$(echo "scale=5; $v" | bc -l)"
echo -e "$a\tsort -S512M -T /dev/shm/sort"
##################################################################
v=0
c=0
for i in $(seq $max);do
  v="$v + $( $time sort -S1024M $f 2>&1 > /dev/null )"
  c=$(( c + 1 ))
done
v="( $v ) / $c"
a="0$(echo "scale=5; $v" | bc -l)"
echo -e "$a\tsort -S 1024M"
##################################################################
v=0
c=0
for i in $(seq $max);do
  v="$v + $( $time sort -S1024M -T /tmp/sort $f 2>&1 > /dev/null )"
  c=$(( c + 1 ))
done
v="( $v ) / $c"
a="0$(echo "scale=5; $v" | bc -l)"
echo -e "$a\tsort -S1024M -T /tmp/sort"
##################################################################
v=0
c=0
for i in $(seq $max);do
  v="$v + $( $time sort -S1024M -T /dev/shm/sort $f 2>&1 > /dev/null )"
  c=$(( c + 1 ))
done
v="( $v ) / $c"
a="0$(echo "scale=5; $v" | bc -l)"
echo -e "$a\tsort -S1024M -T /dev/shm/sort"
