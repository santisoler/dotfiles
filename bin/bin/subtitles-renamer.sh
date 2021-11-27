#!/bin/bash

# Renames subtitles files according to tv shows names found in a directory
# Acceped syntaxes for season/episode are: 304, s3e04, s03e04, 3x04 (case insensitive)
#
# Usage:
# Put this gist somewhere in your $PATH, like /usr/local/bin/subtitles-renamer
# Chmod +x it
# cd ~/YourHolidaysTvShowsWithSubtitles
# subtitles-renamer
#
# Note: zipfiles will be unzipped and .zip will be removed
#
# There are bashisms to work with regular expressions,
# so you really need bash or a shell compatible
#
# Source: https://gist.github.com/colinux/799510

# unzip files, maybe there are subtitles in it...
for f in *.zip; do
  if [ -e "$f" ]; then
    unzip "$f"
    # rm "$f"
  fi
done

# switch into case insensitive
shopt -s nocasematch

# search subtitles
for f in *.{srt,ssa,sub} ; do
  if [ -e "$f" ]; then
    if [[ "$f" =~ s([0-9]+)e([0-9]+) || "$f" =~ ([0-9]+)x([0-9]+) || "$f" =~ ([0-9]+)([0-9][0-9]) ]]; then
      echo "Found '$f'"
      let SEASON="10#${BASH_REMATCH[1]}" # eventually delete leading 0
      EPISODE=${BASH_REMATCH[2]}


      # search for a matching film
      for movie in *.{avi,mkv,mp4} ; do
        if [ -e "$movie" ]; then
          if [[ "$movie" =~ ${SEASON}${EPISODE} || "$movie" =~ s0?${SEASON}e${EPISODE} || "$movie" =~ ${SEASON}x${EPISODE} ]]; then

            NEW_NAME=`echo "${movie%.*}.${f##*.}"`
            if [ "$f" = "${NEW_NAME}" ]; then
              echo "  Already ok"
            elif [ -e "${NEW_NAME}" ]; then
              echo "  A file named '${NEW_NAME}' already exist, skipping"
            else
              mv "$f" "${NEW_NAME}"
              echo "  Renamed '$f' in '${NEW_NAME}'"
            fi
            break;
          fi
        fi
      done
    fi
  fi
done


# reswitch into case sensitive
shopt -u nocasematch

exit 0
