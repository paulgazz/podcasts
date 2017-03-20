#!/bin/bash
cd $(dirname $0)

download_log="./download.log"

if [ $# -lt 3 ]; then
    echo "USAGE: $(basename $0) target_dir fixed_name audio_url podcast_name episode_name"
    exit 1
fi

target_dir="$1"
rawdir="$2"
url="$3"
# rawdir="$4"  # ignore podcast name from feed, it's inconsistent
rawname="$5"
artwork_url="$6"
album=$(echo "$rawdir" | tr "-" " " | tr -d "[:punct:]")
song=$(echo "$rawname" | tr "-" " " | tr -d "[:punct:]")
dir=$(echo "$album" | tr " " "_")
name=$(echo "$song" | tr " " "_")

local_path="$dir/$name.mp3"

# check if file was downloaded already
grep $local_path $download_log >/dev/null
if [ ${?} -eq 1 ]; then
    target_path="$target_dir/$local_path"
# if [ ! -f "$target_path" ]; then
    echo "Downloading the following podcast to $target_path"
    echo $url
    echo $dir
    echo $name

    mkdir -p "$(dirname "$target_path")"
    wget "$url" -O "$target_path"
    id3v2 --album "$album" --song "$song" "$target_path"
    echo "${local_path}" >> "${download_log}"
    # curl -qL $artwork_url > "$target_dir/$dir/artwork.jpg"  # assumes jpg
fi
