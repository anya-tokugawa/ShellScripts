#!/bin/bash -e
if [[ $# -eq 0 ]];then
  echo "usage: $0 [PING_OPTIONS AND HOST]"
  echo "Option:"
  echo " - $0 --kill-state-all  ... Remove State File"
  exit 1
fi


if [[ ! -v FPING_STATE ]];then
  FPING_STATE="$HOME/.fping_state.d/"
fi
set -u

if [[ ! -e "$FPING_STATE" ]];then
 mkdir -p "$FPING_STATE"
fi

if [[ "$1" == "--kill-state-all" ]];then
  rm -f "$FPING_STATE"
  echo "remove state file successfly."
  exit 0
fi

# ping
#result=$(ping -c1 $@ | grep -oP 'time=[0-9]+\.[0-9]+')
t="$(mktemp)"
ping -c1 $@ > "$t"
while read -r line;do
  if (echo "$line" | grep -qP 'time=[0-9]+\.[0-9]+');then
    # eval time=0.0000
    eval "$(echo $line | grep -oP 'time=[0-9]+\.[0-9]+')"
  elif (echo "$line"| grep -qP '^PING');then
    ping_host="$(echo "$line" | cut -d' ' -f3 | tr -d '()')"
  fi
done < "$t"

# Read File
r="${FPING_STATE}/${ping_host}.txt"
if [[ -e "$r" ]];then
  cnt=$(wc -l < "$r")
  min=$(head -1 "$r")
  max=$(tail -1 "$r")
  avg=$(awk '{l+=$3} END{print l/NR;}' "$r")
else
  avg=0
fi

p="${FPING_STATE}/${ping_host}.prev"
if [[ -e "$p" ]];then
  previous=$(< "$p")
else
  previous=0
fi

echo "$time" >> "$r"
sort -n "$r" > "$t"

ncnt=$(wc -l < "$t")
nmin=$(head -1 "$t")
nmax=$(tail -1 "$t")
navg=$(awk '{m+=$1} END{print m/NR;}' "$r")
diff=$(echo "$time - $previous" | bc -l | xargs env printf "%.3f")
echo "cnt/now/avg/max/min/"
echo "$ncnt/$time($diff)/$navg/$nmax/$nmin"

cat "$t" > "$r"
echo "$time" > "$p"
