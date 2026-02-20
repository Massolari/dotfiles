#!/bin/bash

# <xbar.title>Real CPU Usage</xbar.title>
# <xbar.author>Mat Ryer and Tyler Bunnell</xbar.author>
# <xbar.author.github>matryer</xbar.author.github>
# <xbar.desc>Calcualtes and displays real CPU usage stats.</xbar.desc>
# <xbar.version>1.0</xbar.version>

if [ "$1" == "activitymonitor" ]; then
	open -a "Activity Monitor"
	exit
fi

IDLE=$(top -F -R -l3 | grep "CPU usage" | tail -1 | egrep -o '[0-9]{0,3}\.[0-9]{0,2}% idle' | sed 's/% idle//')

GRAPHCHARS='▁▂▃▄▅▆▇█'

CPU_USED=$(echo 100 - "$IDLE" | bc)

CPU_INDEX=$(echo "$CPU_USED / 12.5" | bc)
if [ "$CPU_INDEX" -gt 7 ]; then
    CPU_INDEX=7
fi

# Array of graph characters (0-7)
GRAPHCHARS=('▁' '▂' '▃' '▄' '▅' '▆' '▇' '█')
CPU_GRAPH="${GRAPHCHARS[$INDEX]}"

# Get memory usage
MEM_FREE=$(memory_pressure | awk '/System-wide memory free percentage:/ {print $5}' | sed 's/%//')
MEM_USED=$(echo "100 - $MEM_FREE" | bc)
MEM_INDEX=$(echo "$MEM_USED / 12.5" | bc)
if [ "$MEM_INDEX" -gt 7 ]; then
    MEM_INDEX=7
fi

MEM_GRAPH="${GRAPHCHARS[$MEM_INDEX]}"

DISK_TOTAL=$(df -H / | tail -1 | awk '{print $2}')
DISK_FREE=$(df -H / | tail -1 | awk '{print $4}')

echo "􀫥$CPU_USED%  􀫦$MEM_USED%  􀤂$DISK_FREE"
echo "---"
echo "CPU Usage: $CPU_USED%"
echo "Memory Usage: $MEM_USED%"
echo "Disk Usage: $DISK_FREE/$DISK_TOTAL"
echo "Open Activity Monitor| bash='$0' param1=activitymonitor terminal=false"
