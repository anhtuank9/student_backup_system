#!/bin/bash

# ==============================
# Student Backup System
# ==============================

PROJECT_DIR="/home/ubuntu/student_backup_system"
DATA_DIR="$PROJECT_DIR/data"
BACKUP_DIR="$PROJECT_DIR/backups"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/backup.log"

# Mau terminal
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

# Tao cac thu muc can thiet neu chua co
mkdir -p "$DATA_DIR"
mkdir -p "$LOG_DIR"

backup_data() {
    TIME_NOW=$(date +"%Y-%m-%d %H:%M:%S")
    BACKUP_TIME=$(date +"%Y-%m-%d_%H-%M")
    BACKUP_NAME="data_backup_${BACKUP_TIME}.tar.gz"
    BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

    echo "======================================" >> "$LOG_FILE"
    echo "Thoi gian backup: $TIME_NOW" >> "$LOG_FILE"

    # Kiem tra va tao thu muc backups
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${YELLOW}Thu muc backups chua ton tai. Da tao moi.${RESET}"
        echo "Thu muc backups: Da tao moi" >> "$LOG_FILE"
    else
        echo -e "${GREEN}Thu muc backups da ton tai.${RESET}"
        echo "Thu muc backups: Da ton tai" >> "$LOG_FILE"
    fi

    # Kiem tra ket noi Internet
    ping -c 1 -W 2 google.com.vn > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Co ket noi Internet.${RESET}"
        echo "Ket noi Internet: Co ket noi" >> "$LOG_FILE"
    else
        echo -e "${RED}Khong co ket noi Internet.${RESET}"
        echo "Ket noi Internet: Khong co ket noi" >> "$LOG_FILE"
    fi

    # Kiem tra thu muc data
    if [ ! -d "$DATA_DIR" ]; then
        echo -e "${RED}Thu muc data khong ton tai.${RESET}"
        echo "Trang thai backup: That bai - Khong co thu muc data" >> "$LOG_FILE"
        exit 1
    fi

    # Nen thu muc data
    tar -czf "$BACKUP_PATH" -C "$PROJECT_DIR" data

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Backup thanh cong: $BACKUP_NAME${RESET}"
        echo "Ten file backup: $BACKUP_NAME" >> "$LOG_FILE"
        echo "Trang thai backup: Thanh cong" >> "$LOG_FILE"
    else
        echo -e "${RED}Backup that bai.${RESET}"
        echo "Ten file backup: $BACKUP_NAME" >> "$LOG_FILE"
        echo "Trang thai backup: That bai" >> "$LOG_FILE"
        exit 1
    fi

    # BONUS 1: Chi giu lai 5 file backup moi nhat
    ls -1t "$BACKUP_DIR"/data_backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm -f
    echo "Bonus 1: Chi giu lai 5 file backup moi nhat" >> "$LOG_FILE"

    # BONUS 2: Tu dong commit va push len GitHub neu da cau hinh Git
    cd "$PROJECT_DIR"

    if [ -d ".git" ]; then
        git add .

        if git diff --cached --quiet; then
            echo "Git: Khong co thay doi moi de commit" >> "$LOG_FILE"
        else
            CURRENT_BRANCH=$(git branch --show-current)

            if [ -z "$CURRENT_BRANCH" ]; then
                CURRENT_BRANCH="main"
            fi

            git commit -m "Auto backup $BACKUP_TIME"

            git push origin "$CURRENT_BRANCH" > /dev/null 2>&1

            if [ $? -eq 0 ]; then
                echo "Git: Commit va push thanh cong" >> "$LOG_FILE"
            else
                echo "Git: Push that bai" >> "$LOG_FILE"
            fi
        fi
    else
        echo "Git: Project chua duoc khoi tao Git repository" >> "$LOG_FILE"
    fi

    # BONUS 3: Thong bao hoan thanh
    echo -e "${BLUE}Hoan thanh backup.${RESET}"
    echo "Thong bao: Hoan thanh backup luc $TIME_NOW" >> "$LOG_FILE"
}

show_backups() {
    echo -e "${BLUE}===== DANH SACH BACKUP =====${RESET}"
    ls -lh "$BACKUP_DIR" 2>/dev/null

    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}Chua co file backup nao.${RESET}"
    fi
}

show_log() {
    echo -e "${BLUE}===== NOI DUNG LOG =====${RESET}"

    if [ -f "$LOG_FILE" ]; then
        cat "$LOG_FILE"
    else
        echo -e "${YELLOW}Chua co file log.${RESET}"
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
                echo "Da thoat chuong trinh."
                exit 0
                ;;
            *)
                echo -e "${RED}Lua chon khong hop le. Vui long nhap lai.${RESET}"
                ;;
        esac

        echo
    done
}

# Neu cronjob goi script voi tham so backup thi chay backup truc tiep
if [ "$1" = "backup" ]; then
    backup_data
else
    show_menu
fi

