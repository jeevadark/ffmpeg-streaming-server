#!/bin/bash

# Media Server Setup Script for Ubuntu
# Exit on error
set -e

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing dependencies..."
sudo apt install -y ffmpeg build-essential libpcre3 libpcre3-dev libssl-dev zlib1g-dev git

echo "Installing Nginx with RTMP module..."
cd /tmp
wget http://nginx.org/download/nginx-1.25.3.tar.gz
tar -zxvf nginx-1.25.3.tar.gz
git clone https://github.com/arut/nginx-rtmp-module.git
cd nginx-1.25.3
./configure --add-module=../nginx-rtmp-module --with-http_ssl_module
make
sudo make install

echo "Creating directories..."
sudo mkdir -p /tmp/hls
sudo chmod -R 777 /tmp/hls

echo "Configuring Nginx..."
sudo cp config/nginx.conf /usr/local/nginx/conf/nginx.conf
sudo cp config/index.html /usr/local/nginx/html/index.html

echo "Creating systemd service..."
sudo bash -c 'cat > /etc/systemd/system/ffmpeg-stream.service <<EOF
[Unit]
Description=FFmpeg Stream Service
After=network.target

[Service]
ExecStart=/usr/bin/ffmpeg -re -stream_loop -1 -f concat -safe 0 -i /home/$USER/playlist.txt -c:v libx264 -preset veryfast -maxrate 800k -bufsize 1600k -vf "scale=640:360" -c:a aac -b:a 128k -f flv rtmp://localhost/live/stream
Restart=always
User=$USER
Group=$USER

[Install]
WantedBy=multi-user.target
EOF'

echo "Creating playlist..."
cat > ~/playlist.txt <<EOF
file '/path/to/video1.mp4'
file '/path/to/video2.mp4'
EOF

echo "Starting services..."
sudo /usr/local/nginx/sbin/nginx
sudo systemctl enable ffmpeg-stream.service
sudo systemctl start ffmpeg-stream.service

echo ""
echo "Setup complete!"
echo "1. Edit ~/playlist.txt with your video files"
echo "2. Access your stream at: http://$(hostname -I | awk '{print $1}')/"
