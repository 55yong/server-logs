#!/bin/bash

source "$(dirname "$0")/.env"

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
git add .
git commit -m "Add system logs for $DATE"
git branch main $HOSTNAME
git push origin $HOSTNAME
git switch main
git branch -D $HOSTNAME
