#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

set -a
source "$SCRIPT_DIR/.env"
set +a

pactl set-default-source "$DEFAULT_SOURCE"
pactl load-module module-echo-cancel aec_method=webrtc sink_properties=device.description="Noise_Reduction" aec_args="analog_gain_control=0\ digital_gain_control=0"
pactl set-default-source "${DEFAULT_SOURCE}.echo-cancel"
