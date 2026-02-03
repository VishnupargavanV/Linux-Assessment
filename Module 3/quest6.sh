#!/bin/bash

# -----------------------------
# Question 6: Loop & Copy
# -----------------------------

SOURCE_DIR="source"
BACKUP_DIR="backup"
EXTENSION="txt"

# Create backup directory if not exists
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir "$BACKUP_DIR"
fi

# Enable safe globbing
shopt -s nullglob
FILES=( "$SOURCE_DIR"/*."$EXTENSION" )
shopt -u nullglob

# Loop through files
for file in "${FILES[@]}"
do
    filename=$(basename "$file")
    destination="$BACKUP_DIR/$filename"

    if [ -f "$destination" ]; then
        # Copy only if source file is newer
        if [ "$file" -nt "$destination" ]; then
            cp "$file" "$destination"
            echo "Updated: $filename"
        else
            echo "Skipped (not newer): $filename"
        fi
    else
        cp "$file" "$destination"
        echo "Copied: $filename"
    fi
done
