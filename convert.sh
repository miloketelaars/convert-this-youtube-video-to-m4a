#!/usr/bin/env bash
# Usage: ./convert.sh <youtube_url>
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"
mkdir -p "$BIN_DIR"

if [ -z "$1" ]; then
  echo "Usage: ./convert.sh <youtube_url>"
  exit 1
fi

URL="$1"

# Check yt-dlp
if ! command -v yt-dlp &>/dev/null && [ ! -f "$BIN_DIR/yt-dlp" ]; then
  echo "Downloading yt-dlp..."
  curl -sL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$BIN_DIR/yt-dlp"
  chmod +x "$BIN_DIR/yt-dlp"
fi
YTDLP="${BIN_DIR}/yt-dlp"
if command -v yt-dlp &>/dev/null; then
  YTDLP="yt-dlp"
fi

# Check ffmpeg
if ! command -v ffmpeg &>/dev/null && [ ! -f "$BIN_DIR/ffmpeg" ]; then
  echo "Downloading ffmpeg..."
  curl -sL https://github.com/eugeneware/ffmpeg-static/releases/latest/download/ffmpeg-linux-x64 -o "$BIN_DIR/ffmpeg"
  chmod +x "$BIN_DIR/ffmpeg"
fi
FFMPEG="${BIN_DIR}/ffmpeg"
if command -v ffmpeg &>/dev/null; then
  FFMPEG="ffmpeg"
fi

echo "Converting $URL to M4A..."
"$YTDLP" -f 140/ba[ext=m4a]/ba --extract-audio --audio-format m4a --ffmpeg-location "$BIN_DIR" -o "%(title)s.%(ext)s" "$URL"
echo "Done! Saved M4A."
