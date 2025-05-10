#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 [options] <audio_file>"
    echo "Options:"
    echo "  -l, --loop          Loop the audio (use -1 for infinite loop)"
    echo "  -s, --start         Start time in seconds"
    echo "  -e, --end           End time in seconds"
    echo "  -v, --volume        Volume (0-100)"
    echo "  -h, --help          Display this help message"
    exit 1
}

# Default values
LOOP=0
START_TIME=""
END_TIME=""
VOLUME=100
AUDIO_FILE=""

# Check if mpv is installed
if ! command -v mpv &> /dev/null; then
    echo "Error: mpv is not installed. Please install it first."
    exit 1
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -l|--loop)
            LOOP="$2"
            shift 2
            ;;
        -s|--start)
            START_TIME="$2"
            shift 2
            ;;
        -e|--end)
            END_TIME="$2"
            shift 2
            ;;
        -v|--volume)
            VOLUME="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            if [[ -z "$AUDIO_FILE" ]]; then
                AUDIO_FILE="/home/bro/Documents/Streamdeck/Audio/$1"
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

# Check if file exists
if [[ ! -f "$AUDIO_FILE" ]]; then
    echo "Error: File '$AUDIO_FILE' does not exist"
    exit 1
fi

# Check if audio is already playing
if pgrep -f "mpv.*$AUDIO_FILE" > /dev/null; then
    echo "Audio is already playing. Stopping..."
    pkill -f "mpv.*$AUDIO_FILE"
    exit 0
fi

# Build mpv command
MPV_CMD="mpv --no-terminal"

# Add loop option
if [[ "$LOOP" == "-1" ]]; then
    MPV_CMD="$MPV_CMD --loop=0"
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

# Add audio file
MPV_CMD="$MPV_CMD \"$AUDIO_FILE\""

# Execute the command in background and exit
eval "$MPV_CMD &" 