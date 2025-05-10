# Streamdeck Audio Player

A bash script for playing audio files with various options, designed to work with Streamdeck.

[Installation](#installation)

## Features

- Play audio files with customizable options
- Loop audio (including infinite loop)
- Set start and end times
- Control volume
- Select specific audio devices
- Environment variable support via .env file

## Usage

```bash
./sd-play.sh [options] <audio_file>
```

### Options

- `-l, --loop`          Loop the audio (use -1 for infinite loop)
- `-s, --start`         Start time in seconds
- `-e, --end`           End time in seconds
- `-v, --volume`        Volume (0-100)
- `-L, --list`          List available audio devices
- `-d, --device`        Specify audio device to use
- `-h, --help`          Display help message

### Examples

```bash
# Basic usage
./sd-play.sh audio.mp3

# Play with specific options
./sd-play.sh --start=30 --end=120 --volume=80 audio.mp3

# Play on specific device
./sd-play.sh --device=alsa/default audio.mp3

# Loop infinitely
./sd-play.sh --loop=-1 audio.mp3

# List available audio devices
./sd-play.sh --list
```

### Environment Variables (.env)

You can create a `.env` file in the same directory as the script to set default options and environment variables. The script will automatically source this file if it exists.

Example `.env` file:
```bash
# Default mpv options
MPV_OPTS="--no-terminal --no-resume-playback --no-keep-open"

# Default audio device
AUDIO_DEVICE="alsa/default"

# Working directory for mpv
PWD="/path/to/your/audio/files"
```

### Notes

- The script uses `mpv` for audio playback
- Audio files can be specified with relative or absolute paths
- If an audio file is already playing, running the script again with the same file will stop it
- The script exits immediately after starting playback
- Environment variables from `.env` are loaded before any command-line options are processed

## Requirements

- `mpv` media player
- Bash shell
- Linux/Unix environment

## Installation

### Dependencies
- `mpv` media player
- `bash` shell
- `realpath` (usually comes with coreutils)

### Package Manager Installation

#### Arch Linux
```bash
sudo pacman -S mpv
```

#### Fedora
```bash
sudo dnf install mpv
```

#### Ubuntu/Debian
```bash
sudo apt install mpv
```

#### CentOS/RHEL
```bash
sudo yum install epel-release
sudo yum install mpv
```

#### macOS (using Homebrew)
```bash
brew install mpv
```

#### Windows (using Chocolatey)
```bash
choco install mpv
```

#### Windows Subsystem for Linux (WSL)
```bash
# For Ubuntu/Debian-based WSL
sudo apt install mpv

# For Fedora-based WSL
sudo dnf install mpv
```

### Manual Installation

1. Download the latest mpv release from [mpv.io](https://mpv.io/installation/)
2. Follow the build instructions for your platform
3. Make sure the `mpv` binary is in your system PATH

### Script Installation

1. Clone this repository or download the script
2. Make the script executable:
```bash
chmod +x sd-play.sh
```
3. (Optional) Create a `.env` file in the same directory as the script
4. Test the installation:
```bash
./sd-play.sh --help
```
