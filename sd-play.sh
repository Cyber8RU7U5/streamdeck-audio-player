#!/bin/bash

# Security settings
set -euo pipefail
IFS=$'\n\t'

# Create config directory and file if they don't exist
CONFIG_DIR="$HOME/.config/streamdeck-audio-player"
CONFIG_FILE="$CONFIG_DIR/config"

if [[ ! -d "$CONFIG_DIR" ]]; then
    mkdir -p "$CONFIG_DIR"
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "# StreamDeck Audio Player Configuration" > "$CONFIG_FILE"
    echo "PWD=\"$(pwd)\"" >> "$CONFIG_FILE"
fi

# Source config file
if [[ -f "$CONFIG_FILE" ]]; then
    # Check if config is a regular file
    if [[ ! -f "$CONFIG_FILE" ]] || [[ -L "$CONFIG_FILE" ]]; then
        echo "Error: Invalid config file"
        exit 1
    fi
    # Check if config is owned by the current user
    if [[ "$(stat -c %u "$CONFIG_FILE")" != "$(id -u)" ]]; then
        echo "Error: Config file must be owned by the current user"
        exit 1
    fi
    source "$CONFIG_FILE"
fi

# Function to sanitize path
sanitize_path() {
    local path="$1"
    # Convert to absolute path
    path=$(realpath -- "$path")
    echo "$path"
}

# Function to validate numeric input
validate_number() {
    local num="$1"
    if ! [[ "$num" =~ ^-?[0-9]+$ ]]; then
        echo "Error: '$num' is not a valid number"
        exit 1
    fi
}

# Function to display usage
usage() {
    echo "Usage: $0 [options] <audio_file>"
    echo "Options:"
    echo "  -l, --loop          Loop the audio (use -1 for infinite loop)"
    echo "  -s, --start         Start time in seconds"
    echo "  -e, --end           End time in seconds"
    echo "  -v, --volume        Volume (0-100)"
    echo "  -L, --list          List available audio devices"
    echo "  -d, --device        Specify audio device to use"
    echo "  -h, --help          Display this help message"
    exit 1
}

# Default values
LOOP=0
START_TIME=""
END_TIME=""
VOLUME=100
AUDIO_FILE=""
AUDIO_DEVICE=""

# Check if mpv is installed
if ! command -v mpv &> /dev/null; then
    echo "Error: mpv is not installed. Please install it first."
    exit 1
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -l=*|--loop=*)
            LOOP="${1#*=}"
            validate_number "$LOOP"
            shift
            ;;
        -l|--loop)
            LOOP="$2"
            validate_number "$LOOP"
            shift 2
            ;;
        -s=*|--start=*)
            START_TIME="${1#*=}"
            validate_number "$START_TIME"
            shift
            ;;
        -s|--start)
            START_TIME="$2"
            validate_number "$START_TIME"
            shift 2
            ;;
        -e=*|--end=*)
            END_TIME="${1#*=}"
            validate_number "$END_TIME"
            shift
            ;;
        -e|--end)
            END_TIME="$2"
            validate_number "$END_TIME"
            shift 2
            ;;
        -v=*|--volume=*)
            VOLUME="${1#*=}"
            validate_number "$VOLUME"
            if [[ "$VOLUME" -lt 0 ]] || [[ "$VOLUME" -gt 100 ]]; then
                echo "Error: Volume must be between 0 and 100"
                exit 1
            fi
            shift
            ;;
        -v|--volume)
            VOLUME="$2"
            validate_number "$VOLUME"
            if [[ "$VOLUME" -lt 0 ]] || [[ "$VOLUME" -gt 100 ]]; then
                echo "Error: Volume must be between 0 and 100"
                exit 1
            fi
            shift 2
            ;;
        -L|--list)
            echo "Available audio devices:"
            mpv --audio-device=help
            exit 0
            ;;
        -d=*|--device=*)
            AUDIO_DEVICE="${1#*=}"
            # Basic sanitization of device name
            if [[ ! "$AUDIO_DEVICE" =~ ^[a-zA-Z0-9_/.-]+$ ]]; then
                echo "Error: Invalid device name"
                exit 1
            fi
            shift
            ;;
        -d|--device)
            AUDIO_DEVICE="$2"
            # Basic sanitization of device name
            if [[ ! "$AUDIO_DEVICE" =~ ^[a-zA-Z0-9_/.-]+$ ]]; then
                echo "Error: Invalid device name"
                exit 1
            fi
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            if [[ -z "$AUDIO_FILE" ]]; then
                AUDIO_FILE="$PWD/$1"
            else
                echo "Error: Unexpected argument: $1"
                usage
            fi
            shift
            ;;
    esac
done

# Check if audio file is provided
if [[ -z "$AUDIO_FILE" ]]; then
    echo "Error: No audio file specified"
    usage
fi

# Sanitize and validate the audio file path
AUDIO_FILE_ABS=$(sanitize_path "$AUDIO_FILE")

# Check if file exists and is a regular file
if [[ ! -f "$AUDIO_FILE_ABS" ]] || [[ -L "$AUDIO_FILE_ABS" ]]; then
    echo "Error: File '$AUDIO_FILE_ABS' does not exist or is not a regular file"
    exit 1
fi

# Find the PID(s) of mpv playing exactly this file
PIDS=""
if pgrep -x mpv > /dev/null; then
    PIDS=$(pgrep -af "mpv" 2>/dev/null | awk -v file="$AUDIO_FILE_ABS" '
        {
            for (i=2; i<=NF; i++) {
                if ($i == file) {
                    print $1
                    exit
                }
            }
        }
    ' || echo "")
fi

if [[ -n "$PIDS" ]]; then
    echo "This exact audio file is already playing. Stopping..."
    # Validate PIDs before killing
    for pid in $PIDS; do
        if [[ ! "$pid" =~ ^[0-9]+$ ]]; then
            echo "Error: Invalid PID found"
            exit 1
        fi
        # Check if the process is actually mpv
        if ! ps -p "$pid" -o comm= | grep -q "^mpv$"; then
            echo "Error: Process $pid is not mpv"
            exit 1
        fi
    done
    kill $PIDS
    exit 0
fi

# Build mpv command
MPV_CMD="mpv --no-terminal --no-resume-playback --no-keep-open"

# Add audio device if specified
if [[ -n "$AUDIO_DEVICE" ]]; then
    MPV_CMD="$MPV_CMD --audio-device='$AUDIO_DEVICE'"
fi

# Add loop option
if [[ "$LOOP" == "-1" ]]; then
    MPV_CMD="$MPV_CMD --loop=inf"
else
    MPV_CMD="$MPV_CMD --loop=$LOOP"
fi

# Add start time if specified
if [[ -n "$START_TIME" ]]; then
    MPV_CMD="$MPV_CMD --start=$START_TIME"
fi

# Add end time if specified
if [[ -n "$END_TIME" ]]; then
    MPV_CMD="$MPV_CMD --end=$END_TIME"
fi

# Add volume
MPV_CMD="$MPV_CMD --volume=$VOLUME"

# Add audio file (using sanitized path)
MPV_CMD="$MPV_CMD \"$AUDIO_FILE_ABS\""

# Execute the command in background with proper process management
nohup bash -c "$MPV_CMD" > /dev/null 2>&1 &
disown 