#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

log() {
  local datetime="$(date '+%Y-%m-%d %H:%M:%S')"
  local log_message="[${datetime}]: $1"
  local log_file='/tmp/log_file_for_maximize_keyboard_brightness'
  printf '%s\n' "${log_message}" | sudo tee --append "${log_file}" &>/dev/null
}

maximize_brightness() {
  local brightness_file='/sys/class/leds/tpacpi::kbd_backlight/brightness'
  local max_brightness='2'
  printf '%s' "${max_brightness}" | sudo tee "${brightness_file}" &>/dev/null
}

# log "I ran as $(whoami)"
maximize_brightness
# log 'I succeeded'
