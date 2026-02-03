#!/bin/bash

# -----------------------------
# Question 5: Conditionals
# -----------------------------

BACKUP_DIR="backup"

# Check if directory exists
if [ -d "$BACKUP_DIR" ]; then
    echo "Backup directory already exists."
else
    echo "Backup directory does not exist."
    echo "Creating backup directory..."
    mkdir "$BACKUP_DIR"
    echo "Backup directory created."
fi
