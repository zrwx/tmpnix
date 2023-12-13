#!/usr/bin/env bash
PS4="\e[34m[$(basename "${0}")"':${FUNCNAME[0]:+${FUNCNAME[0]}():}${LINENO:-}]: \e[0m'
IFS=$'\n\t'
set -uxo pipefail

lock() {
  i3lock \
    --ignore-empty-password \
    --nofork \
    --debug \
    --verif-text='' \
    --wrong-text='' \
    --noinput-text='' \
    --lock-text='' \
    --image="${XDG_CONFIG_HOME}/assets/current_lockscreen.png"
}

main() {
  dunstctl set-paused true
  lock
  dunstctl set-paused false
}

main "$@"
