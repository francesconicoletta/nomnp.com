#!/bin/zsh

# BSD Zero Clause License
#
# Copyright (c) 2023 Francesco Nicoletta Puzzillo
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

# README
# This script will change all your previously saved monitors' scale from 1 to 2.
# This is useful on 1920x1080 monitors, since macOS renders text way better
# with scale 2. You can verify scaling has changed by looking at the Safari
# icon on the dock. If some of the dashes (compass degrees indicators?) are
# longer than others you are on scale 2. If all the dashes are still of the
# same length after running this script and rebooting, you can try to change
# the external display orientation and putting it back to normal before
# retrying. This creates an entry for your monitor on the "displays" file. Then
# run the script again. macOS needs to reboot to apply these changes.
# This script does not work on Intel based macs.

set -euo

TEMPFILE="/tmp/displayscaling/com.apple.windowserver.displays.plist"

mkdir -p "$(dirname $TEMPFILE)"
cp /Library/Preferences/com.apple.windowserver.displays.plist "$(dirname $TEMPFILE)"
plutil -convert xml1 "$TEMPFILE"
sed -i '' -e '/<key>Scale<\/key>/ {' -e 'n; s/<real>1<\/real>/<real>2<\/real>/' -e '}' "$TEMPFILE"
plutil -convert binary1 "$TEMPFILE"
sudo cp "$TEMPFILE" /Library/Preferences/com.apple.windowserver.displays.plist
rm "$TEMPFILE"
rmdir "$(dirname $TEMPFILE)"
rm "$HOME/Library/Preferences/ByHost/com.apple.windowserver.displays.*"
printf "\nmacOS needs to reboot to apply these changes."
