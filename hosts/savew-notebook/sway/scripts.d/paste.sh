#!/bin/sh

url="https://paste.savew.dev"
filepath="$1"
filename=$(basename -- "$filepath")
extension="${filename##*.}"

response=$(curl --data-binary @${filepath:-/dev/stdin} --url $url)
echo "$url$response"".""$extension" | tee >(wl-copy)