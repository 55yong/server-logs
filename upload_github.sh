#!/bin/bash

HOSTNAME=$(hostname)

# GitHub 리포지토리 경로
REPO_DIR=/root/server-logs/$HOSTNAME
# 로그 파일이 저장된 경로
LOG_DIR=/var/log/system
# 오늘 날짜
DATE=$(date +"%Y-%m-%d")
DATE_DIR="$REPO_DIR/$DATE"
# 월
MONTH=$(date +"%Y-%m")
MONTHLY_FILE="monthly_summary_${MONTH}.log"

# 복사 대상 로그 파일들
FILES=(
  "cpu_mem_$DATE.log"
  "disk_detail_$DATE.log"
  "summary_$DATE.log"
)

# 오늘 날짜 디렉토리 생성
if [ ! -d "$DATE_DIR" ]; then
    mkdir "$DATE_DIR"
fi

# 로그 복사
for file in "${FILES[@]}"; do
    if [ -f "$LOG_DIR/$file" ]; then
        cp "$LOG_DIR/$file" "$DATE_DIR/$file"
    fi
done

if [ -f "$LOG_DIR/$MONTHLY_FILE" ]; then
    cp "$LOG_DIR/$MONTHLY_FILE" "$REPO_DIR/$MONTHLY_FILE"
fi

cd "$REPO_DIR"

# Git 작업
git add *
git commit -m "Add system logs for $DATE"
git push origin $HOSTNAME
