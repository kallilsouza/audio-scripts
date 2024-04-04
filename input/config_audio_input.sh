#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

set -a
source "$SCRIPT_DIR/.env"
set +a

pactl set-default-source "$DEFAULT_SOURCE"
pactl load-module module-echo-cancel aec_method=webrtc sink_properties=device.description="Noise_Reduction" aec_args="analog_gain_control=0\ digital_gain_control=0"

NEW_DEVICE_NAME="${DEFAULT_SOURCE}.echo-cancel"

pactl set-default-source $NEW_DEVICE_NAME

if [[ $VOLUME =~ ^[0-9]+$ ]]; then
    pactl set-source-volume "${NEW_DEVICE_NAME}.echo-cancel" $VOLUME%
fi
