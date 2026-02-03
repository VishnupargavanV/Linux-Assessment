#!/bin/bash

# -----------------------------
# Question 4: Arrays
# -----------------------------

SOURCE_DIR="source"
EXTENSION="txt"

# Enable safe globbing
shopt -s nullglob
FILES=( "$SOURCE_DIR"/*."$EXTENSION" )
shopt -u nullglob

# Display number of files
echo "Number of files found: ${#FILES[@]}"

# Loop through array elements
for file in "${FILES[@]}"
do
    echo "File: $file"
done
