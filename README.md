# Streamdeck Audio Player

A bash script for playing audio files with various options, designed to work with Streamdeck.

This script was made to do some extra tasks before actually playing the audio. The main part is to stop the audio if it is already playing, I need this for my Dungeons and Dragon campaign.

The [`streamdeck-ui`](https://timothycrosley.github.io/streamdeck-ui/) is missing this option, hence this GPT-o4-mini vibe-coded repository.

*For the people hunting for easter eggs, try and find my username via the way Cursor AI works. ~ Happy hunting*

## GPT-o4-mini: Security Notice

This script is designed for personal use and accepts certain security trade-offs for convenience:

- **Path Access**: The script can access any file path on the system. This is intentional for flexibility but means it should be used with care.
- **Process Management**: The script will only stop mpv processes that are playing the exact same file.
- **Input Validation**: All numeric inputs and device names are validated to prevent command injection.
- **Environment Variables**: The .env file is checked for proper ownership and file type.

## Documentation

- [Changelog](CHANGELOG.md) - History of changes
- [Contributing](CONTRIBUTING.md) - How to contribute
- [License](LICENSE) - MIT License

Have fun!

## Quick Start

```bash
# Clone the repository
git clone https://github.com/Cyber8RU7U5/streamdeck-audio-player.git
cd streamdeck-audio-player

# Make the script executable
chmod +x sd-play.sh

# Run the script
./sd-play.sh audio.mp3
```

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
- `git` (for cloning the repository)

### Package Manager Installation

#### Arch Linux
```bash
# Install dependencies
sudo pacman -S mpv git

# Clone and setup
git clone https://github.com/Cyber8RU7U5/streamdeck-audio-player.git
cd streamdeck-audio-player
chmod +x sd-play.sh

# Create alias (add to ~/.bashrc or ~/.zshrc)
echo 'alias sd-play="~/path/to/streamdeck-audio-player/sd-play.sh"' >> ~/.bashrc
source ~/.bashrc
```

#### Fedora
```bash
# Install dependencies
sudo dnf install mpv git

# Clone and setup
git clone https://github.com/Cyber8RU7U5/streamdeck-audio-player.git
cd streamdeck-audio-player
chmod +x sd-play.sh

# Create alias (add to ~/.bashrc or ~/.zshrc)
echo 'alias sd-play="~/path/to/streamdeck-audio-player/sd-play.sh"' >> ~/.bashrc
source ~/.bashrc
```

#### Ubuntu/Debian
```bash
# Install dependencies
sudo apt install mpv git

# Clone and setup
git clone https://github.com/Cyber8RU7U5/streamdeck-audio-player.git
cd streamdeck-audio-player
chmod +x sd-play.sh

# Create alias (add to ~/.bashrc or ~/.zshrc)
echo 'alias sd-play="~/path/to/streamdeck-audio-player/sd-play.sh"' >> ~/.bashrc
source ~/.bashrc
```

#### CentOS/RHEL
```bash
# Install dependencies
sudo yum install epel-release
sudo yum install mpv git

# Clone and setup
git clone https://github.com/Cyber8RU7U5/streamdeck-audio-player.git
cd streamdeck-audio-player
chmod +x sd-play.sh

# Create alias (add to ~/.bashrc or ~/.zshrc)
echo 'alias sd-play="~/path/to/streamdeck-audio-player/sd-play.sh"' >> ~/.bashrc
source ~/.bashrc
```

#### macOS (using Homebrew)
```bash
# Install dependencies
brew install mpv git

# Clone and setup
git clone https://github.com/Cyber8RU7U5/streamdeck-audio-player.git
cd streamdeck-audio-player
chmod +x sd-play.sh

# Create alias (add to ~/.zshrc or ~/.bash_profile)
echo 'alias sd-play="~/path/to/streamdeck-audio-player/sd-play.sh"' >> ~/.zshrc
source ~/.zshrc
```

#### Windows (using Chocolatey)
```bash
# Install dependencies
choco install mpv git

# Clone and setup (in Git Bash or WSL)
git clone https://github.com/Cyber8RU7U5/streamdeck-audio-player.git
cd streamdeck-audio-player
chmod +x sd-play.sh

# Create alias (add to ~/.bashrc)
echo 'alias sd-play="~/path/to/streamdeck-audio-player/sd-play.sh"' >> ~/.bashrc
source ~/.bashrc
```

#### Windows Subsystem for Linux (WSL)
```bash
# For Ubuntu/Debian-based WSL
sudo apt install mpv git

# For Fedora-based WSL
sudo dnf install mpv git

# Clone and setup
git clone https://github.com/Cyber8RU7U5/streamdeck-audio-player.git
cd streamdeck-audio-player
chmod +x sd-play.sh

# Create alias (add to ~/.bashrc)
echo 'alias sd-play="~/path/to/streamdeck-audio-player/sd-play.sh"' >> ~/.bashrc
source ~/.bashrc
```

### Manual Installation

1. Download the latest mpv release from [mpv.io](https://mpv.io/installation/)
2. Follow the build instructions for your platform
3. Make sure the `mpv` binary is in your system PATH
4. Clone the repository:
```bash
git clone https://github.com/Cyber8RU7U5/streamdeck-audio-player.git
cd streamdeck-audio-player
chmod +x sd-play.sh

# Create alias (add to your shell's rc file)
echo 'alias sd-play="~/path/to/streamdeck-audio-player/sd-play.sh"' >> ~/.bashrc
source ~/.bashrc
```

### Script Installation

1. Clone this repository or download the script
2. Make the script executable:
```bash
chmod +x sd-play.sh
```
3. (Optional) Create a `.env` file in the same directory as the script
4. Create an alias (add to your shell's rc file):
```bash
echo 'alias sd-play="~/path/to/streamdeck-audio-player/sd-play.sh"' >> ~/.bashrc
source ~/.bashrc
```
5. Test the installation:
```bash
sd-play --help
```
