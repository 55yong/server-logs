#!/bin/bash

source .env

YEAR=$(date +%Y)
MONTH=$(date +%m)
OUT_FILE="$LOG_DIR/monthly_summary_${YEAR}-${MONTH}.log"

# 대상 파일 목록 (예: summary_2025-06-01.log ~ summary_2025-06-30.log)
FILES=$(ls "$LOG_DIR"/summary_${YEAR}-${MONTH}-*.log 2>/dev/null)

# 초기값
cpu_sum=0
mem_sum=0
count=0

for file in $FILES; do
    cpu=$(grep "CPU usage" "$file" | awk -F':' '{print $2}' | xargs)
    mem=$(grep "MEM usage" "$file" | awk -F':' '{print $2}' | xargs)

    if [[ $cpu != "" && $mem != "" ]]; then
        cpu_sum=$(echo "$cpu_sum + $cpu" | bc)
        mem_sum=$(echo "$mem_sum + $mem" | bc)
        count=$((count + 1))
    fi
done

# 평균 계산
if [ $count -gt 0 ]; then
    cpu_avg=$(echo "scale=2; $cpu_sum / $count" | bc)
    mem_avg=$(echo "scale=2; $mem_sum / $count" | bc)
else
    cpu_avg="N/A"
    mem_avg="N/A"
fi

# 출력
echo "===== ${YEAR}-${MONTH} monthly usage average =====" > "$OUT_FILE"
echo "CPU usage avg (%): $cpu_avg" >> "$OUT_FILE"
echo "MEM usage avg (%): $mem_avg" >> "$OUT_FILE"
