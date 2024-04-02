# input audio scripts

The script "config_audio_input.sh" is executed by Linux during its startup, to set my microphone as the default input device, as well as loading the echo-cancel module (pulseaudio).

I use ```shpactl list sources``` to get the list of input devices in the system.