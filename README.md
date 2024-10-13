# Vid2Nokia

A script that can convert a video into the .3gp format playable on Nokia 3310 (2017) and compatible devices.

## Usage

Download the script into a folder where the video is located. Make script executable and then run "./vid2nokia.sh filename.extension" to convert the video.
You can run "./vid2nokia.sh -f" to convert all videos in the current folder.
You can run "./vid2nokia.sh -y URL" to download and convert video using yt-dlp.

## Requirements

Requires [ffmpeg](https://www.ffmpeg.org/) and [bc](https://www.gnu.org/software/bc/) to be installed. Requires [yt-dlp](https://github.com/yt-dlp/yt-dlp) for the -y flag to work. Written and tested on Manjaro Linux.

## Notice

As of the current version, the script crops the picture to fit Nokia 3310's 4:3 display. It always preserves the center of the picture, cutting off whatever exceeds the native resolution. In the future the script may be adjusted to allow for other methods of adjusting the video output.