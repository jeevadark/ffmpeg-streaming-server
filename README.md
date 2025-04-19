# Ubuntu Media Server with FFmpeg and Nginx RTMP

This project sets up a media server on Ubuntu with:
- Nginx with RTMP module
- FFmpeg for video streaming
- HLS streaming capability
- Web-based player

## Requirements
- Ubuntu 20.04/22.04
- sudo privileges

## Installation
```bash
chmod +x setup.sh run.sh
./setup.sh

## Usage
## After setup, streaming will start automatically. To manually control streaming:

## Start streaming:


./run.sh
Access the web player at: http://your-server-ip/

## Configuration
## Edit playlist.txt to add your video files

## Edit config/nginx.conf for Nginx configuration
