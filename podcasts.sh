#!/bin/bash

conf="$(dirname $0)/podcasts.conf"  # default config file
filter="head -n1"  # download latest by default
links="$(dirname $0)/links.log"  # list of podcast links from rss feeds
rssparser="$(dirname $0)/parse_enclosure.xsl"  # rss parser
lockfile="$0.lock"  # lock file
outdir=""  # default outdir, blank for none
listcmd="tac"  # order in which to download podcasts
newSpeed=1

# download podcasts
while getopts ":an:f:o:s:" opt; do
  case $opt in
    a)
      # download all available podcasts
      filter="cat"
      ;;
    n)
      # download last n podcasts
      filter="head -n${OPTARG}"
      ;;
    f)
      if [[ $OPTARG == "-" ]]; then
        conf="" # read from standard in
      else
        conf="$OPTARG"
      fi
      ;;
    o)
      outdir="${OPTARG}"
      mkdir -p "${outdir}"
      if [[ "${?}" != "0" ]]; then
        echo "unable to create output directory ${outdir}" >&2
        exit 1
      fi
      ;;
    s)
      newSpeed="${OPTARG}"
      re='^[0-9]+([.][0-9]+)?$'
      if ! [[ $newSpeed =~ $re ]]; then
        echo "Option -s requires a number" >&2
        exit 1
      fi
      if [[ $(echo "$newSpeed>2" | bc) -eq 1 ]]; then
        echo "Max speed-up value (option -s) is 2" >&2
        exit 1
      fi
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# check for output dir
if [[ ! -d "${outdir}" ]]; then
    echo "no output directory specified with -o" >&2
    exit 1
fi

# check for conf file
if [[ ! -f "${conf}" && "${conf}" != "" ]]; then
    echo "invalid config file ${conf}" >&2
    exit 1
fi

(
# echo "wait for lock on /var/lock/.unison_sync.exclusivelock (fd 200) for 10 seconds"
flock -x -w 10 200 || exit 1

# get list of links of each rss feed
cat $conf | grep -v "^#" | while read line; do
  podcast=$(echo "${line}" | cut -f1)
  show=$(echo "${line}" | cut -f2)
  echo $show >&2
  curl -qL "${podcast}" | xsltproc $rssparser - | $filter | awk -v show="${show}" '{print "\""show"\" "$0}'
done > "${links}"

# download each podcast from the list of links
${listcmd} "${links}" | xargs -L1 "$(dirname $0)/get_podcast.sh" "${outdir}" "${newSpeed}"

) 200>"${lockfile}"
