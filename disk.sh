#!/bin/bash

source ".env"

mkdir -p "$LOG_DIR"
DATE=$(date +"%Y-%m-%d")
TIME=$(date +"%H:%M")
OUT_FILE="$LOG_DIR/disk_detail_$DATE.log"

# 함수: 필요한 열만 추출
get_disk_info() {
    mount_point=$1
    df -h "$mount_point" | awk 'NR==1 {next} {print $2","$3","$4","$5}'
}

# 기록 시작
echo "$TIME,/,`get_disk_info /`" >> "$OUT_FILE"
