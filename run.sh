#!/bin/bash

# Define variables
INPUT_FILE="/home/jeevarsc/playlist.txt"
RTMP_URL="rtmp://localhost/live/stream"

# Run FFmpeg command
ffmpeg -re -stream_loop -1 -f concat -safe 0 -i "$INPUT_FILE" \
       -c:v libx264 -preset veryfast -maxrate 800k -bufsize 1600k \
       -vf "scale=640:360" -c:a aac -b:a 128k -f flv "$RTMP_URL"
