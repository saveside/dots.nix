#!@bash@

time=$(date +"%H:%M")
date=$(date +%d/%m/%Y)
volume=$(echo $(@pamixer@ --get-volume))
@dunst@/bin/dunstify "Vol: $volume  $time  $date"