#!/bin/bash


echo "Waiting for X server"
until [[ -e /var/run/appconfig/xserver_ready ]]; do sleep 1; done
echo "X server is ready"

# Set the max window size.
# Setting the limits here will force the window into these dimensions before starting the recording.
IFS='x' read -ra maxres <<< $(xrandr | head | grep -o "maximum.*" | sed 's/maximum//' | tr -d ' ')
MAX_WINDOW_WIDTH=${maxres[0]}
MAX_WINDOW_HEIGHT=${maxres[1]}

export WARP_SERVER_HOST="${WARP_HOST:-"localhost"}"
export WARP_SERVER_PORT="${WARP_PORT:-4443}"
export WARP_ADDRESS="${WARP_ADDRESS:-$WARP_SERVER_HOST:$WARP_SERVER_PORT}"

# Generate a random 16 character name by default. for each container
URL_NAME="${NAME:-$(head /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | head -c 16)}"

#Full server url
export WARP_FULL_URL="${URL:-"https://$WARP_ADDRESS/$URL_NAME"}"

echo "INFO: catch the stream at ${WARP_FULL_URL}"

#1920x1080
ffmpeg -hide_banner -loglevel error -s ${MAX_WINDOW_WIDTH}x${MAX_WINDOW_HEIGHT} -r 30 -f x11grab -i :0 -f pulse -re -i tcp:${PULSE_SERVER} -f mp4 -streaming 1 -movflags empty_moov+frag_every_frame+separate_moof+omit_tfhd_offset - | /usr/bin/warp -- ${WARP_FULL_URL}


#gst-launch-1.0 -e ... ! x264enc ... ! h264parse ! mp4mux streamable=true fragment-duration=100 presentation-time=true ! ...
#gst-launch-1.0 -v ximagesrc use-damage=0 ! videoconvert ! videoscale ! video/x-raw,width=${MAX_WINDOW_WIDTH},height=${MAX_WINDOW_HEIGHT},framerate=30/1 ! x264enc tune=zerolatency bitrate=5000 ! mp4mux streamable=true ! fdsink fd=1 pulsesrc device=${PULSE_DEVICE} ! audioconvert ! voaacenc bitrate=128000 ! queue ! mux.