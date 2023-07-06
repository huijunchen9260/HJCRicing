#! /bin/sh -e

while date '+C  %b %d, %Y   %a %H:%M '; do
    sleep "${POLLING_RATE:-60}"
done