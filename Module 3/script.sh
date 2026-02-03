#!/bin/bash

# -----------------------------
# Step 1: Export variable
# -----------------------------
export BACKUP_COUNT=0

SOURCE_DIR="source"
BACKUP_DIR="backup"
EXTENSION="txt"

# Create backup directory if not exists
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir "$BACKUP_DIR"
fi

# -----------------------------
# Step 2: Globbing
# -----------------------------
shopt -s nullglob
FILES=( "$SOURCE_DIR"/*."$EXTENSION" )
shopt -u nullglob

# -----------------------------
# Step 3: Backup and count
# -----------------------------
for file in "${FILES[@]}"
do
    cp "$file" "$BACKUP_DIR/"
    BACKUP_COUNT=$((BACKUP_COUNT + 1))
done

# -----------------------------
# Step 4: Display results
# -----------------------------
echo "Files backed up: $BACKUP_COUNT"

# 🔴 PROOF that variable is exported
echo "Checking exported environment variable:"
env | grep BACKUP_COUNT
