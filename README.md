# podcasts.sh

This script downloads podcast episodes and tags the audio file with
show and episode name in id3v2 format.  It can either download the
latest episodes or all episodes.

## Dependencies

- Bash shell script
- Using the following unix command: `head`, `cat`, `tac`
- Uses both `curl` and `wget`
- Uses `xsltproc` to run an rss parser
- Uses `id3v2` to tag downloaded audio files with podcast name and episode

## Setup

Copy `podcasts.conf.sample` to `podcasts.conf` and add and remove
shows as desired.  The format is one line per show, with the rss url
and name of the podcast separated by a tab.

## Usage

To download the latest podcast from each show, run

    ./podcasts.sh -o /path/to/store/podcasts

This will download the latest podcasts from each show in
`podcasts.conf` and store them in the given directory under show-name
subdirectories.

## Advanced Usage

To download all podcasts instead of the latest, use `-a`.  Specify
different lists of shows using `-f`.  For instance, to download all
episodes of a single show from the default config file do

    grep Crypto podcasts.conf | ./podcasts -a -f - -o /path/to/store/podcasts
