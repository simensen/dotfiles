#!/bin/sh

find $(realpath ~/Code) -type d -name node_modules -print0 -prune -exec tmutil addexclusion "{}" \;
find $(realpath ~/.lima) -type f -name basedisk -print0 -prune -exec tmutil addexclusion "{}" \;
find $(realpath ~/.lima) -type f -name diffdisk -print0 -prune -exec tmutil addexclusion "{}" \;

tmutil addexclusion "$(realpath ~/Creative\ Cloud\ Files)"
tmutil addexclusion "$(realpath ~/Dropbox)"
tmutil addexclusion "$(realpath ~/Library/Caches)"
tmutil addexclusion "$(realpath ~/Library/Mobile\ Documents/com\~apple\~CloudDocs)"
tmutil addexclusion "$(realpath ~/Pictures/Photos\ Library.photoslibrary)"

