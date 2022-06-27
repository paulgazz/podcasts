# podcasts.sh

This script downloads podcast episodes and tags the audio file with
show and episode name in id3v2 format.  It can either download the
latest episodes or all episodes.

## Dependencies

- Bash shell script
- Using the following unix commands: `head`, `cat`, `tac` (`tac` may
  not be available in all unix flavors.  If not, change `listcmd` to
  `cat` in `podcasts.sh`)
- Uses `flock` for file locking
- Uses both `curl` and `wget`
- Uses `xsltproc` to run an rss parser (may need to install `xsltproc`
  package)
- Uses `id3v2` to tag downloaded audio files with podcast name and
  episode (may need to install `id3v2` package)

## Setup

Copy `podcasts.conf.sample` to `podcasts.conf` and add and remove
shows as desired.  The format is one line per show, with the rss url
and name of the podcast separated by a tab.  (This assumes show names
do not have tabs.)

## Usage

To download the latest podcast from each show, run

    ./podcasts.sh -o /path/to/store/podcasts

This will download the latest podcasts from each show in
`podcasts.conf` and store them in the given directory under show name
subdirectories.  This script is very convenient for using in crontab, e.g., to download podcasts every hour

    0 * * * * /path/to/podcasts.sh -o /path/to/store/podcasts > /tmp/podcasts.out 2>&1

The script will automatically maintain a log (`download.log`) of
previously downloaded podcasts to avoid ever redownloading them.

## Advanced Usage

### Download all podcast episodes

To download all podcasts instead of the latest, use `-a`.  Specify
different lists of shows using `-f`.  For instance, to download all
episodes of a single show from the default config file do

    grep Crypto podcasts.conf | ./podcasts.sh -a -f - -o /path/to/store/podcasts

### Download several of the most recent episodes

To download several of the most recent episodes, use `-n` with a
number parameter, e.g., the following will download the ten most
recent episodes:

    grep Crypto podcasts.conf | ./podcasts.sh -n10 -f - -o /path/to/store/podcasts

