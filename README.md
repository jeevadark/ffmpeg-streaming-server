# ffmpeg-streaming-server
Before getting started. step: 1 Download an Ubuntu server install and set up on VMWARE. Step: 2 And create a file named playlist.txt on your /home/<ubuntu>/playlist.txt Step: 3 And create a directory named (video) on /home/<ubuntu>/video Step: 4 And upload a <video.mp4> file on video directory Step: 5 To Upload a <fmpeg_Ubuntu_setup >folder on video directory use SCP Step: 6 ./ setup_media_server # make execute chmod +x setup_media_server Step: 7 ./update_ setup_media_server # make execute chmod +x update_setup_media_server Step: 8 ./run.sh # Make excute chmod +x run.sh
Method : Using SCP (Secure Copy)
SCP is a secure way to transfer files between your local machine and the Ubuntu server.
1.
Ensure SSH is enabled on the Ubuntu server:
o
Log in to your Ubuntu server via the VMware console or SSH.
o
Install and enable SSH if it’s not already installed: sudo apt update sudo apt install openssh-server sudo systemctl enable ssh sudo systemctl start ssh
2.
Find the IP address of the Ubuntu server:
o
Run the following command on the Ubuntu server: ip a
o
Note the IP address (e.g., 192.168.x.x).
3.
Copy the file using SCP from Windows:
o
Open a terminal on Windows (e.g., Command Prompt, PowerShell, or Windows Terminal).
o
Use the scp command to transfer the file:
scp "C:\path\to\your\video.mp4" username@ubuntu_server_ip:/path/to/destination/
o
Replace:
▪ C:\path\to\your\video.mp4 with the full path to your video file on Windows.
▪
username with your Ubuntu server username.
▪ ubuntu_server_ip with the IP address of your Ubuntu server.
▪ /path/to/destination/ with the directory on the Ubuntu server where you want to save the file.
4.
Enter your Ubuntu server password when prompted.
STEP: 1
How to Use the Script
1.
Save the Script: Save the script as setup_media_server.sh on your Ubuntu server.
2.
Make the Script Executable: chmod +x setup_media_server.sh
3.
Run the Script: ./setup_media_server.sh
What the Script Does
1.
Installs Dependencies:
o
FFmpeg, build tools, and libraries for Nginx.
2.
Compiles and Configures Nginx:
o
Sets up Nginx with the RTMP module and HLS support.
3.
Creates a Web-Based HLS Player:
o
Sets up a web page to play the HLS stream.
4.
Sets Up FFmpeg Streaming:
o
Streams a playlist of videos in a loop to the RTMP server.
5.
Automates FFmpeg:
o
Creates a systemd service to ensure FFmpeg runs continuously.
6.
Displays Success Message:
o
Provides the URL for the HLS player and the location of the playlist file.
Post-Setup Steps
1.
Edit the Playlist:
o
Update the /home/ubuntu/playlist.txt file with the paths to your videos.
2.
Access the HLS Player:
o
Open the HLS player in a browser:
http://<ubuntu_server_ip>/index.html
3.
Test on Hospital TVs:
o
Use VLC or a web browser on the TVs to access the HLS stream.
STEP: 2
How to Use the Updated Script
Save the Script:
Save the script as update_setup_media_server.sh on your Ubuntu server.
Make the Script Executable: chmod +x update_setup_media_server.sh
Run the Script: ./update_setup_media_server.sh
Enter Video Paths:
When prompted, enter the full paths to your video files. Type done when you’re finished.
How It Works
1.
Playlist Creation:
o
The script prompts you to enter the full paths to your video files.
o
It validates each path to ensure the file exists.
o
You can type done to finish adding files.
2.
Playlist File:
o
The playlist file is created at /home/ubuntu/playlist.txt.
o
It contains the paths to the videos you entered.
3.
FFmpeg Streaming:
o
FFmpeg streams the videos in the playlist in a loop.
4.
Automation:
o
A systemd service is created to ensure FFmpeg runs continuously.
How to Use the Updated Script
1.
Save the Script: Save the script as setup_media_server.sh on your Ubuntu server.
2.
Make the Script Executable: chmod +x setup_media_server.sh
3.
Run the Script: ./setup_media_server.sh
4.
Enter Video Paths:
o
When prompted, enter the full paths to your video files.
o
Type done when you’re finished.
Example Interaction
Enter the full path to a video file (or type 'done' to finish): /home/ubuntu/videos/video1.mp4
Added: /home/ubuntu/videos/video1.mp4
Enter the full path to a video file (or type 'done' to finish): /home/ubuntu/videos/video2.mp4
Added: /home/ubuntu/videos/video2.mp4
Enter the full path to a video file (or type 'done' to finish): done
Playlist created at: /home/ubuntu/playlist.txt
Post-Setup Steps
1.
Access the HLS Player: Open the HLS player in a browser:
http://<ubuntu_server_ip>/index.html
2.
Edit the Playlist: If you need to update the playlist later, edit the file: nano /home/ubuntu/playlist.txt
3.
Restart FFmpeg: If you update the playlist, restart the FFmpeg service: sudo systemctl restart ffmpeg-stream.service
Steps to Use:
1.
Save the script as run.sh: nano run.sh Paste the script and save it (CTRL + X, then Y, then Enter).
2.
Make it executable: chmod +x run.sh
3.
Run the script: ./run.sh
This will continuously loop your playlist and stream it via RTMP.
