#!/bin/bash

export BACKUP_COUNT=0

for file in *.txt
do
    BACKUP_COUNT=$((BACKUP_COUNT + 1))
done

echo "Files backed up: $BACKUP_COUNT"
