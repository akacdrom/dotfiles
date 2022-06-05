#! /bin/bash
totalMem=$(awk 'NR==1 {print $2}' /proc/meminfo)
awk 'NR==3 {printf "%.0f", ($2/'$totalMem')*100}' /proc/meminfo