#!/bin/bash

# -------------------------------
# Step 1: Command-line arguments
# -------------------------------
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source_directory> <backup_directory> <file_extension>"
    exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="$2"
EXTENSION="$3"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist."
    exit 1
fi

# --------------------------------
# Step 2: Create backup directory
# --------------------------------
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create backup directory."
        exit 1
    fi
fi

# --------------------------------
# Step 3: Globbing files
# --------------------------------
shopt -s nullglob
FILES=( "$SOURCE_DIR"/*."$EXTENSION" )
shopt -u nullglob

if [ "${#FILES[@]}" -eq 0 ]; then
    echo "No files with extension .$EXTENSION found."
    exit 0
fi

# --------------------------------
# Step 4: Export variable
# --------------------------------
export BACKUP_COUNT=0
TOTAL_SIZE=0
REPORT_FILE="$BACKUP_DIR/backup_report.log"

# --------------------------------
# Step 5: Display files before backup
# --------------------------------
echo "Files to be backed up:" | tee "$REPORT_FILE"
for file in "${FILES[@]}"; do
    size=$(stat -c %s "$file")
    echo "$(basename "$file") - $size bytes" | tee -a "$REPORT_FILE"
done

# --------------------------------
# Step 6: Backup process
# --------------------------------
for file in "${FILES[@]}"; do
    filename=$(basename "$file")
    destination="$BACKUP_DIR/$filename"

    if [ -f "$destination" ]; then
        if [ "$file" -nt "$destination" ]; then
            cp "$file" "$destination"
        else
            continue
        fi
    else
        cp "$file" "$destination"
    fi

    size=$(stat -c %s "$file")
    TOTAL_SIZE=$((TOTAL_SIZE + size))
    BACKUP_COUNT=$((BACKUP_COUNT + 1))
done

# --------------------------------
# Step 7: Summary report
# --------------------------------
{
echo "---------------------------"
echo "Backup Summary"
echo "Total files processed: ${#FILES[@]}"
echo "Total files backed up: $BACKUP_COUNT"
echo "Total size backed up: $TOTAL_SIZE bytes"
echo "Backup directory: $BACKUP_DIR"
} >> "$REPORT_FILE"

echo "Backup completed successfully."
echo "Report saved at $REPORT_FILE"
echo "Argument 1 (Source): $1"
echo "Argument 2 (Backup): $2"
echo "Argument 3 (Extension): $3"
