#!/bin/bash

# Function to create the playlist file
create_playlist() {
    echo "Creating playlist file..."
    PLAYLIST_PATH="/home/ubuntu/playlist.txt"
    echo -n "" > "$PLAYLIST_PATH" # Clear the file if it exists

    while true; do
        read -p "Enter the full path to a video file (or type 'done' to finish): " VIDEO_PATH
        if [[ "$VIDEO_PATH" == "done" ]]; then
            break
        elif [[ -f "$VIDEO_PATH" ]]; then
            echo "file '$VIDEO_PATH'" >> "$PLAYLIST_PATH"
            echo "Added: $VIDEO_PATH"
        else
            echo "File not found: $VIDEO_PATH"
        fi
    done

    if [[ ! -s "$PLAYLIST_PATH" ]]; then
        echo "No valid video files were added. Exiting."
        exit 1
    fi

    echo "Playlist created at: $PLAYLIST_PATH"
}

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install FFmpeg and dependencies for Nginx
sudo apt install -y ffmpeg build-essential libpcre3 libpcre3-dev libssl-dev zlib1g-dev git

# Download and compile Nginx with RTMP module
cd /tmp
wget http://nginx.org/download/nginx-1.25.3.tar.gz
tar -zxvf nginx-1.25.3.tar.gz
git clone https://github.com/arut/nginx-rtmp-module.git
cd nginx-1.25.3
./configure --add-module=../nginx-rtmp-module --with-http_ssl_module
make
sudo make install

# Create HLS directory
sudo mkdir -p /tmp/hls
sudo chmod -R 777 /tmp/hls

# Configure Nginx
sudo bash -c 'cat > /usr/local/nginx/conf/nginx.conf <<EOF
worker_processes  1;

events {
    worker_connections  1024;
}

rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            record off;
            hls on;
            hls_path /tmp/hls;
            hls_fragment 3;
            hls_playlist_length 60;
        }
    }
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }

        location /hls {
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            root /tmp;
            add_header Cache-Control no-cache;
            add_header Access-Control-Allow-Origin *;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}
EOF'

# Create a web-based HLS player
sudo bash -c 'cat > /usr/local/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>HLS Stream</title>
    <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
</head>
<body>
    <video id="video" controls width="640" height="360"></video>
    <script>
        if (Hls.isSupported()) {
            var video = document.getElementById("video");
            var hls = new Hls();
            hls.loadSource("http://$(hostname -I | awk "{print \$1}")/hls/stream.m3u8");
            hls.attachMedia(video);
            hls.on(Hls.Events.MANIFEST_PARSED, function() {
                video.play();
            });
        } else if (video.canPlayType("application/vnd.apple.mpegurl")) {
            video.src = "http://$(hostname -I | awk "{print \$1}")/hls/stream.m3u8";
            video.addEventListener("loadedmetadata", function() {
                video.play();
            });
        }
    </script>
</body>
</html>
EOF'

# Start Nginx
sudo /usr/local/nginx/sbin/nginx

# Create the playlist file
create_playlist

# Automate FFmpeg streaming with the playlist
sudo bash -c 'cat > /etc/systemd/system/ffmpeg-stream.service <<EOF
[Unit]
Description=FFmpeg Stream Service
After=network.target

[Service]
ExecStart=/usr/bin/ffmpeg -re -stream_loop -1 -f concat -safe 0 -i /home/ubuntu/playlist.txt -c:v libx264 -preset veryfast -maxrate 800k -bufsize 1600k -vf "scale=640:360" -c:a aac -b:a 128k -f flv rtmp://localhost/live/stream
Restart=always
User=ubuntu
Group=ubuntu

[Install]
WantedBy=multi-user.target
EOF'

# Enable and start the FFmpeg service
sudo systemctl enable ffmpeg-stream.service
sudo systemctl start ffmpeg-stream.service

# Display success message
echo "Media server setup complete!"
echo "Access the HLS player at: http://$(hostname -I | awk '{print $1}')/index.html"
echo "Edit the playlist file at: /home/ubuntu/playlist.txt"
