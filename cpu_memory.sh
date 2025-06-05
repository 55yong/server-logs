#!/bin/bash

source ".env"

DATE=$(date +"%Y-%m-%d")
TIME=$(date +"%H:%M")

# CPU 사용률: top에서 idle 제외
CPU=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print 100 - $1}')
# 메모리 사용률: used / total 비율
MEM=$(free | awk '/Mem:/ {printf "%.2f", $3/$2 * 100}')

echo "$TIME,CPU:$CPU,MEM:$MEM" >> "$LOG_DIR/cpu_mem_$DATE.log"
