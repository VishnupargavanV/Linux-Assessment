#!/bin/bash

INPUT_FILE="/home/vishnu/Downloads/input.txt"
OUTPUT_FILE="output.txt"

# Clear output file if it exists
> "$OUTPUT_FILE"

frame_time=""
fc_type=""
fc_subtype=""

while IFS= read -r line; do
    if [[ $line == *"frame.time"* ]]; then
        frame_time=$(echo "$line" | cut -d':' -f2- | xargs)
    elif [[ $line == *"wlan.fc.type"* ]]; then
        fc_type=$(echo "$line" | cut -d':' -f2- | xargs)
    elif [[ $line == *"wlan.fc.subtype"* ]]; then
        fc_subtype=$(echo "$line" | cut -d':' -f2- | xargs)
    fi

    if [[ -n "$frame_time" && -n "$fc_type" && -n "$fc_subtype" ]]; then
        echo "\"frame.time\": \"$frame_time\"," >> "$OUTPUT_FILE"
        echo "\"wlan.fc.type\": \"$fc_type\"," >> "$OUTPUT_FILE"
        echo "\"wlan.fc.subtype\": \"$fc_subtype\"" >> "$OUTPUT_FILE"

        frame_time=""
        fc_type=""
        fc_subtype=""
    fi
done < "$INPUT_FILE"

echo "Done. Output saved to output.txt"
