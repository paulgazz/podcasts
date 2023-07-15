#!/bin/bash
cd $(dirname $0)

download_log="./download.log"

if [ $# -lt 4 ]; then
    echo "USAGE: $(basename $0) target_dir speed fixed_name audio_url podcast_name episode_name artwork_url pubdate"
    exit 1
fi

target_dir="$1"
speed="$2"
rawdir="$3"
url="$4"
# rawdir="$5"  # ignore podcast name from feed, it's inconsistent
rawname="$6"
artwork_url="$7"
rawdate="$8"
echo "RAWDATE: $rawdate"
album=$(echo "$rawdir" | tr "-" " " | tr -d "[:punct:]")
song=$(echo "$rawname" | tr "-" " " | tr -d "[:punct:]")
dir=$(echo "$album" | tr " " "_")
pubdate=$(echo "$rawdate" | tr "-" " " | tr -d "[:punct:]" | tr " " "_")
name=$(echo "$song" | tr " " "_")

local_path="$dir/$name.mp3"
# local_path="${dir}_${pubdate}.mp3"

# check if file was downloaded already
grep $local_path $download_log >/dev/null
if [[ ${?} -eq 1 || ${?} -eq 2 ]]; then
    target_path="$target_dir/$local_path"
# if [ ! -f "$target_path" ]; then
    echo "Downloading the following podcast to $target_path"
    echo $url
    echo $dir
    echo $name
    echo $pubdate

    mkdir -p "$(dirname "$target_path")"
    wget "$url" -O "$target_path"
    id3v2 --album "$album" --song "$song" "$target_path"
    echo "${local_path}" >> "${download_log}"

    # If desired speed is different than 1, change the speed
    if [[ $(echo "$speed==1" | bc) -ne 1 ]]; then
        mv $target_dir/$local_path "$target_dir/$dir/tmp.mp3"
        ffmpeg -y -i "$target_dir/$dir/tmp.mp3" -filter:a "atempo=$speed" -vn $target_dir/$local_path
        rm "$target_dir/$dir/tmp.mp3"
    fi
     
    # curl -qL $artwork_url > "$target_dir/$dir/artwork.jpg"  # assumes jpg
fi
