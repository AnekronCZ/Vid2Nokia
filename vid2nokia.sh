#!/bin/bash

convert_video() {
    local input_file=$1
    local output_file="${input_file%.*}_nokia.3gp"
    dimensions=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$input_file")
    width=$(echo $dimensions | cut -d'x' -f1)
    height=$(echo $dimensions | cut -d'x' -f2)
    if [ "$width" -gt "$height" ]; then
        # Horizontal video (aspect ratio wider than 4:3)
        echo "Processing horizontal video: $input_file"
        new_width=$(echo "$width * 240 / $height" | bc)
        crop_amount=$(echo "($new_width - 320) / 2" | bc)
        ffmpeg -i "$input_file" -vf "scale=$new_width:240,crop=320:240:$crop_amount:0" -c:v mpeg4 -c:a aac -b:v 300k "$output_file"
    else
        # Vertical video (aspect ratio taller than 4:3)
        echo "Processing vertical video: $input_file"
        new_height=$(echo "$height * 320 / $width" | bc)
        crop_amount=$(echo "($new_height - 240) / 2" | bc)
        ffmpeg -i "$input_file" -vf "scale=320:$new_height,crop=320:240:0:$crop_amount" -c:v mpeg4 -c:a aac -b:v 300k "$output_file"
    fi
}

if [ "$1" == "-y" ] && [ ! -z "$2" ]; then
    echo "Downloading video from URL: $2"
    yt-dlp -f "bestvideo[height<=?240]+bestaudio/best" -o "%(title).15s.%(ext)s" "$2"
    downloaded_file=$(yt-dlp --get-filename -o "%(title).15s.%(ext)s" "$2")
    if [ -f "$downloaded_file" ]; then
        echo "Downloaded file: $downloaded_file"
        convert_video "$downloaded_file"
        rm "$downloaded_file"
    else
        echo "Error: Video download failed."
        exit 1
    fi

    exit 0
fi


if [ "$1" == "-f" ]; then
    for file in *.mp4 *.webm *.mkv *.wmv *.mov *.avi *.MP4 *.WEBM *.MKV *.WMV *.MOV *.AVI; do
        if [ -f "$file" ]; then
            convert_video "$file"
        fi
    done

elif [ -f "$1" ]; then
    convert_video "$1"

else
    echo "vid2nokia:"
    echo "./vid2nokia.sh filename.extension  - Convert a single file"
    echo "./vid2nokia.sh -f                  - Convert all video files in the folder"
    echo "./vid2nokia.sh -y url              - Download a video and convert it"
fi
