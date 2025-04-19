#!/bin/bash

# Media Server Run Script
# Starts FFmpeg streaming with the configured playlist

# Get local IP
IP=$(hostname -I | awk '{print $1}')

echo "Starting FFmpeg stream..."
echo "Stream will be available at: http://$IP/"

ffmpeg -re -stream_loop -1 -f concat -safe 0 -i ~/playlist.txt \
       -c:v libx264 -preset veryfast -maxrate 800k -bufsize 1600k \
       -vf "scale=640:360" -c:a aac -b:a 128k -f flv rtmp://localhost/live/stream
