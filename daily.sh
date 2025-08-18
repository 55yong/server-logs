#!/bin/bash

source "$(dirname "$0")/.env"

DATE=$(date +"%Y-%m-%d")

COLLECT_FILE="$LOG_DIR/cpu_mem_$DATE.log"
OUT_FILE="$LOG_DIR/daily_$DATE.log"

# === CPU 평균 계산 ===
CPU_AVG=$(awk -F'CPU:' '{split($2,a,","); sum+=a[1]; n++} END {if(n>0) printf "%.2f", sum/n; else print "N/A"}' "$COLLECT_FILE")
MEM_AVG=$(awk -F'MEM:' '{sum+=$2; n++} END {if(n>0) printf "%.2f", sum/n; else print "N/A"}' "$COLLECT_FILE")

# === 디스크 평균 계산 함수 ===
disk_usage() {
    mount_point=$1

    if [ -z "$mount_point" ]; then
      echo "Usage: $0 <mount_point>"
      exit 1
    fi

    df -h "$mount_point" | awk 'NR==1 {next} {printf "%s usage: %s (total: %s)\n", $6, $3, $2}'
}

# uptime
UPTIME=$(uptime -p)


# === 출력 ===
echo "===== $DATE daily usage average =====" > "$OUT_FILE"
echo "CPU usage(%): $CPU_AVG" >> "$OUT_FILE"
echo "MEM usage(%): $MEM_AVG" >> "$OUT_FILE"

echo $(disk_usage "/")  >> "$OUT_FILE"

echo "Uptime: $UPTIME" >> "$OUT_FILE"
echo "" >> "$OUT_FILE"
