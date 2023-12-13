#!/usr/bin/env bash

THRESHOLD_WARN="20"
THRESHOLD_SUSPEND="7"
COUNTDOWN_SUSPEND="15"

below_threshold() {
  local status="$(cat /sys/class/power_supply/BAT0/status)"
  local capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  local threshold="$1"
  [[ "${status}" == "Discharging" && "${capacity}" -le "${threshold}" ]]
}

warn() {
  local capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  notify-send --urgency=critical "Battery low (${capacity}%)" "$@"
}

suspend() {
  warn "Shutting down in ${COUNTDOWN_SUSPEND}s"
  sleep "${COUNTDOWN_SUSPEND}"
  systemctl suspend
}

main() {
  if below_threshold "${THRESHOLD_SUSPEND}"; then
    suspend
  elif below_threshold "${THRESHOLD_WARN}"; then
    warn
  fi
}

main
