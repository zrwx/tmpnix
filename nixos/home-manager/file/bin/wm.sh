#!/usr/bin/env bash
PS4_raw="$(basename "${0}")"':${FUNCNAME[0]:+${FUNCNAME[0]}():}${LINENO:-}]: '
PS4="\e[34m[${PS4_raw}\e[0m"
IFS=$'\n\t'
set -euxo pipefail

log() {
  local msg="${*}"
  notify-send "${msg}"
  <<<"${msg}" &>>/dev/stderr
}

die() {
  log "${@}"
  exit 1
}

brightness() {
  local verb="${1}"
  shift
  case "${verb}" in
    inc)
      local delta="${1:-10}"
      brightnessctl set "+${delta}%"
      ;;
    dec)
      local curr="$(brightnessctl get)"
      local max="$(brightnessctl max)"
      local dec="${1:-10}"
      local new="$(python -c "print(int(max(1, 100 * ${curr}/${max} - ${dec})))")"
      brightnessctl set "${new}%"
      ;;
    set) brightnessctl set "${1}" ;;
    *) ;;
  esac
}

volume() {
  local verb="${1}"
  shift
  case "${verb}" in
    mute) pamixer --mute --set-volume 0 ;;
    inc) pamixer --increase "${1:-3}" ;;
    dec) pamixer --decrease "${1:-3}" ;;
    set) pamixer --set-volume "${1}" ;;
    toggle) pamixer --toggle-mute ;;
    *) ;;
  esac
}

mic() {
  local verb="${1:-toggle}"
  local cmd=(pactl set-source-mute '@DEFAULT_SOURCE@')
  case "${verb}" in
    on) "${cmd[@]}" 0 ;;
    off) "${cmd[@]}" 1 ;;
    toggle) "${cmd[@]}" "${verb}" ;;
    *) die "${FUNCNAME[0]}: invalid ${verb}" ;;
  esac
}

lock() {
  i3lock.sh
}

sleep() {
  systemctl suspend
}

network() {
  local verb="${1:-}"
  shift
  case "${verb}" in
    disconnect) 
      local network="${1}"
      nmcli device wifi disconnect "${network}"
      ;;
    connect) 
      local network="${1}"
      if [[ "$#" -gt '1' ]]; then
        local password="${2}"
        nmcli device wifi connect "${network}" password "${password}"
      else
        nmcli device wifi connect "${network}"
      fi
      ;;
    list) nmcli device wifi "${verb}" ;;
    on|off) nmcli radio wifi "${verb}" ;;
    status) nmcli device status ;;
    list) ;;
    *) ;;
  esac
}

mute_all() {
  volume mute
  mic off
}

gpt_clip() {
  local verb="${1:-}"
  local cmd=(sgpt --model 'gpt-4')
  if [[ "${verb}" != 'chatty' ]]; then
    cmd+=('--code')
  fi
  clip -o | "${cmd[@]}" | clip
}

main() {
  if [[ "$#" -lt 1 ]]; then
    die 'invalid argc'
  fi
  local verb="${1}"
  shift
  case "${verb}" in
    brightness|volume|mic|lock|sleep|network|mute_all|gpt_clip) "${verb}" "$@" ;;
  esac
}

main "$@"
