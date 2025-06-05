#!/bin/bash

source ".env"

DATE=$(date +"%Y-%m-%d")

CPU_MEM_FILE="$LOG_DIR/cpu_mem_$DATE.log"
DISK_FILE="$LOG_DIR/disk_detail_$DATE.log"
OUT_FILE="$LOG_DIR/summary_$DATE.log"

# === CPU 평균 계산 ===
CPU_AVG=$(awk -F'CPU:' '{split($2,a,","); sum+=a[1]; n++} END {if(n>0) printf "%.2f", sum/n; else print "N/A"}' "$    CPU_MEM_FILE")
MEM_AVG=$(awk -F'MEM:' '{sum+=$2; n++} END {if(n>0) printf "%.2f", sum/n; else print "N/A"}' "$CPU_MEM_FILE")

# === 디스크 평균 계산 함수 ===
disk_avg_info() {
    grep "$1" "$DISK_FILE" | awk -F',' -v target="$1" '
    {
        gsub("G", "", $3); # Used
        gsub("G", "", $4); # Size
        gsub("%", "", $6); # Use%
        total_size+=$3;
        total_used+=$4;
        total_percent+=$6;
        count++;
    }
    END {
        if (count > 0) {
            avg_percent = total_percent / count;
            avg_used = total_used / count;
            avg_size = total_size / count;
            printf "%.2f|%.0fG|%.0fG", avg_percent, avg_used, avg_size;
        } else {
            print "N/A|N/A|N/A";
        }
    }'
}

# '/' 평균
ROOT_INFO=$(disk_avg_info "/")
ROOT_PERCENT=$(echo $ROOT_INFO | cut -d'|' -f1)
ROOT_USED=$(echo $ROOT_INFO | cut -d'|' -f2)
ROOT_SIZE=$(echo $ROOT_INFO | cut -d'|' -f3)

# uptime
UPTIME=$(uptime -p)


# === 출력 ===
echo "===== $DATE daily usage average =====" > "$OUT_FILE"
echo "CPU usage(%): $CPU_AVG" >> "$OUT_FILE"
echo "MEM usage(%): $MEM_AVG" >> "$OUT_FILE"

echo "/ usage: $ROOT_USED (total: $ROOT_SIZE)" >> "$OUT_FILE"

echo "Uptime: $UPTIME" >> "$OUT_FILE"
