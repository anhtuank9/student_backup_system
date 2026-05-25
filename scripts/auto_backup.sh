#!/bin/bash

#!/bin/bash

# ==============================
# Student Backup System
# Auto Backup + Menu + GitHub
# ==============================

PROJECT_DIR="/home/ubuntu/student_backup_system"
DATA_DIR="$PROJECT_DIR/data"
BACKUP_DIR="$PROJECT_DIR/backups"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/backup.log"

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

mkdir -p "$DATA_DIR"
mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"

backup_data() {
    TIME_NOW=$(date +"%Y-%m-%d %H:%M:%S")
    BACKUP_TIME=$(date +"%Y-%m-%d_%H-%M")
    BACKUP_NAME="data_backup_${BACKUP_TIME}.tar.gz"
    BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

    echo "======================================" >> "$LOG_FILE"
    echo "Thoi gian backup: $TIME_NOW" >> "$LOG_FILE"

    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Thu muc backups: Da tao moi" >> "$LOG_FILE"
    else
        echo "Thu muc backups: Da ton tai" >> "$LOG_FILE"
    fi

    ping -c 1 -W 2 google.com.vn > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "Ket noi Internet: Co ket noi" >> "$LOG_FILE"
    else
        echo "Ket noi Internet: Khong co ket noi" >> "$LOG_FILE"
    fi

    if [ ! -d "$DATA_DIR" ]; then
        echo "Trang thai backup: That bai - Khong tim thay thu muc data" >> "$LOG_FILE"
        echo "Backup that bai: Khong tim thay thu muc data"
        exit 1
    fi

    tar -czf "$BACKUP_PATH" -C "$PROJECT_DIR" data

    if [ $? -eq 0 ]; then
        echo "Ten file backup: $BACKUP_NAME" >> "$LOG_FILE"
        echo "Trang thai backup: Thanh cong" >> "$LOG_FILE"
        echo "Backup thanh cong: $BACKUP_NAME"
    else
        echo "Ten file backup: $BACKUP_NAME" >> "$LOG_FILE"
        echo "Trang thai backup: That bai" >> "$LOG_FILE"
        echo "Backup that bai"
        exit 1
    fi

    # BONUS 1: Chi giu lai 5 file backup moi nhat
    ls -1t "$BACKUP_DIR"/data_backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm -f
    echo "Bonus 1: Chi giu lai 5 file backup moi nhat" >> "$LOG_FILE"

    # BONUS 2: Tu dong commit va push len GitHub
    cd "$PROJECT_DIR"

    if [ -d ".git" ]; then
        # BONUS 3: Thong bao hoan thanh
echo "Thong bao: Hoan thanh backup luc $TIME_NOW" >> "$LOG_FILE"
echo "Hoan thanh backup luc $TIME_NOW"

# BONUS 2: Tu dong commit va push len GitHub
cd "$PROJECT_DIR"

if [ -d ".git" ]; then
    git add .

    if git diff --cached --quiet; then
        echo "Git: Khong co thay doi moi de commit" >> "$LOG_FILE"
    else
        git commit -m "Auto backup $BACKUP_TIME" >> "$LOG_FILE" 2>&1

        GIT_SSH_COMMAND="ssh -i /home/ubuntu/.ssh/id_ed25519 -o StrictHostKeyChecking=accept-new" git push origin main >> "$LOG_FILE" 2>&1

        if [ $? -eq 0 ]; then
            echo "Git: Commit va push thanh cong" >> "$LOG_FILE"
        else
            echo "Git: Push that bai" >> "$LOG_FILE"
        fi
    fi
else
    echo "Git: Project chua duoc khoi tao Git repository" >> "$LOG_FILE"
fi
    else
        echo "Git: Project chua duoc khoi tao Git repository" >> "$LOG_FILE"
    fi

    # BONUS 3: Thong bao hoan thanh
    echo "Thong bao: Hoan thanh backup luc $TIME_NOW" >> "$LOG_FILE"
    echo "Hoan thanh backup luc $TIME_NOW"
}

show_backups() {
    echo -e "${BLUE}===== DANH SACH BACKUP =====${RESET}"
    ls -lh "$BACKUP_DIR"
}

show_log() {
    echo -e "${BLUE}===== NOI DUNG LOG =====${RESET}"

    if [ -f "$LOG_FILE" ]; then
        cat "$LOG_FILE"
    else
        echo "Chua co file log"
    fi
}

show_menu() {
    while true
    do
        echo -e "${BLUE}"
        echo "================================="
        echo "     STUDENT BACKUP SYSTEM"
        echo "================================="
        echo -e "${RESET}"
        echo -e "${GREEN}1. Backup du lieu${RESET}"
        echo -e "${YELLOW}2. Xem danh sach backup${RESET}"
        echo -e "${BLUE}3. Xem log${RESET}"
        echo -e "${RED}4. Thoat${RESET}"
        echo
        read -p "Nhap lua chon cua ban: " choice

        case $choice in
            1)
                backup_data
                ;;
            2)
                show_backups
                ;;
            3)
                show_log
                ;;
            4)
                echo "Da thoat chuong trinh"
                exit 0
                ;;
            *)
                echo "Lua chon khong hop le"
                ;;
        esac

        echo
    done
}

if [ "$1" = "backup" ]; then
    backup_data
else
    show_menu
fi     
