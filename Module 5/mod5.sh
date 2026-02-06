#!/bin/bash
# -------------------------------------------------------
# File: mod5.sh
# Description: Demonstrates recursion, redirection,
# here-doc, here-string, getopts, regex validation,
# special parameters, and error handling.
# -------------------------------------------------------

ERROR_LOG="errors.log"

# -------------------------------
# Special Parameters Demo
# -------------------------------
echo "Script Name        : $0"
echo "Total Arguments    : $#"
echo "All Arguments      : $@"
echo "First Argument     : $1"
echo "Second Argument    : $2"
echo "--------------------------------"

# -------------------------------
# Help Menu (Here Document)
# -------------------------------
show_help() {
cat <<EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>   Directory to search recursively
  -k <keyword>     Keyword to search
  -f <file>        Search keyword in a specific file
  -h               Display this help menu

Examples:
  $0 -d logs -k error
  $0 -f script.sh -k TODO
  $0 -h
EOF
}

# -------------------------------
# Recursive Function
# -------------------------------
recursive_search() {
    local dir="$1"
    local keyword="$2"

    for item in "$dir"/*; do
        if [[ -f "$item" ]]; then
            grep -Hn "$keyword" "$item" 2>>"$ERROR_LOG"
        elif [[ -d "$item" ]]; then
            recursive_search "$item" "$keyword"
        fi
    done
}

# -------------------------------
# Validate Inputs using Regex
# -------------------------------
validate_inputs() {
    if [[ ! "$KEYWORD" =~ ^[a-zA-Z0-9._-]+$ ]]; then
        echo "Invalid keyword: $KEYWORD" | tee -a "$ERROR_LOG"
        exit 1
    fi
}

# -------------------------------
# Search in a Single File (Here String)
# -------------------------------
search_file() {
    local file="$1"
    local keyword="$2"

    if [[ ! -f "$file" ]]; then
        echo "File not found: $file" | tee -a "$ERROR_LOG"
        exit 1
    fi

    grep -n "$keyword" <<< "$(cat "$file")"
}

# -------------------------------
# Command-line Arguments (getopts)
# -------------------------------
while getopts ":d:k:f:h" opt; do
    case $opt in
        d) DIRECTORY="$OPTARG" ;;
        k) KEYWORD="$OPTARG" ;;
        f) FILE="$OPTARG" ;;
        h)
            show_help
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" | tee -a "$ERROR_LOG"
            show_help
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." | tee -a "$ERROR_LOG"
            exit 1
            ;;
    esac
done

# -------------------------------
# Main Logic
# -------------------------------
validate_inputs

if [[ -n "$DIRECTORY" && -n "$KEYWORD" ]]; then
    if [[ ! -d "$DIRECTORY" ]]; then
        echo "Directory not found: $DIRECTORY" | tee -a "$ERROR_LOG"
        exit 1
    fi
    recursive_search "$DIRECTORY" "$KEYWORD"

elif [[ -n "$FILE" && -n "$KEYWORD" ]]; then
    search_file "$FILE" "$KEYWORD"

else
    echo "Missing required arguments." | tee -a "$ERROR_LOG"
    show_help
    exit 1
fi
