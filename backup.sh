#!/bin/bash

# Load configuration
CONFIG_FILE="$(dirname "$0")/backup.conf"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file is not found: $CONFIG_FILE"
    exit 1
fi
source "$CONFIG_FILE"

# Prepare filenames
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
backup_file="$BACKUP_DIR/backup_$timestamp.tar.gz"
log_file="$LOG_DIR/backup_$timestamp.log"
latest_log="$LOG_DIR/latest.log"

# Create log and backup
{
    echo "Backup started: $(date)"
    
    # Check if target directory exists
    if [ ! -d "$TARGET_DIR" ]; then
        echo "Target directory $TARGET_DIR does not exist."
        echo "Backup failed." | mail -s "Backup Failed: Directory Missing" "$ALERT_EMAIL"
        exit 1
    fi

    # Perform backup
    if tar -czf "$backup_file" "$TARGET_DIR"; then
        echo "Backup successful: $backup_file"
    else
        echo " Backup failed while creating archive"
        echo "Backup failed during archiving." | mail -s "Backup Failed: archiving error" "$ALERT_EMAIL"
        exit 1
    fi

    # Backup rotation
    echo "Rotating backups (keeping last $RETENTION_DAYS) "
    ls -tp "$BACKUP_DIR"/backup_*.tar.gz | grep -v '/$' | tail -n +$((RETENTION_DAYS + 1)) | xargs -r rm -f

    # Log rotation
    echo "Rotating logs (keeping last $LOG_RETENTION)"
    ls -tp "$LOG_DIR"/backup_*.log | grep -v '/$' | tail -n +$((LOG_RETENTION + 1)) | xargs -r rm -f

    echo "Backup finished: $(date)"
} | tee "$log_file" > "$latest_log"
