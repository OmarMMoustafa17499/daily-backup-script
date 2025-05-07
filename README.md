#Daily System Backup Script (Bash)

This project automates daily system backups using a Bash script. It supports log rotation, backup retention, and email alerts for failures using Postfix.

---

##Features

- Backup a specified directory (`/etc`, `/var/www`, etc.)
- Save compressed backups to a chosen location
- Rotate backups (keep last **7** by default)
- Rotate logs (keep last **5** by default)
- Alert for local Postfix mail if the backup fails
- Runs automatically every day according to cron job

---

##Files and Structure

backup-script/

backup.sh     # Main backup script
backup.conf   # Configurable variables
cronjob.txt   # Cron entry for automation
README.md     # Documentation

