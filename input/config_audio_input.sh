#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

set -a
source "$SCRIPT_DIR/.env"
set +a

check_pulseaudio() {
    pactl info &>/dev/null
    return $?
}

attempts=0
while ! check_pulseaudio; do
    echo "Checking if PulseAudio is running..."

    attempts=$((attempts + 1))
    if [ "$attempts" -ge 5 ]; then
        echo "PulseAudio is not running. Exiting."
        exit 1
    fi
    echo "PulseAudio is not running. Retrying in 5 seconds... (Attempt $attempts of 5)"
    sleep 5
done

echo "PulseAudio is running"

NEW_DEVICE_NAME="echo-cancel-source"

echo "Changing default source to '$DEFAULT_SOURCE'"

NEW_DEFAULT_SOURCE=$DEFAULT_SOURCE

if ! pactl set-default-source "$DEFAULT_SOURCE"; then
    echo "Error: Default source '$DEFAULT_SOURCE' not found. Using the new device name ($NEW_DEVICE_NAME) instead."
    NEW_DEFAULT_SOURCE=$NEW_DEVICE_NAME
    pactl set-default-source "echo-cancel-source"
fi

echo "Default source changed to '$NEW_DEFAULT_SOURCE'"

pactl load-module module-echo-cancel aec_method=webrtc sink_properties=device.description="Noise_Reduction" aec_args="analog_gain_control=0\ digital_gain_control=0"

echo "Changing default source to '$NEW_DEVICE_NAME'"

pactl set-default-source "$NEW_DEVICE_NAME"
echo "Default source changed to '$NEW_DEFAULT_SOURCE'"

if [[ $VOLUME =~ ^[0-9]+$ ]]; then
    echo "Changing the source volume to $VOLUME"
    pactl set-source-volume "${NEW_DEVICE_NAME}" "$VOLUME%"
fi
