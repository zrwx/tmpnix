#!/usr/bin/env bash
PS4="\e[34m[${0:-}:\${LINENO:-}]: \e[0m"
IFS=$'\n\t'
set -euxo pipefail

create_lockscreen() {
  local dimensions="$(xdpyinfo | perl -ne 'print if s/.*dimensions:\s*(\S*)\s*.*/\1/g')"
  local bg='black'
  local new_lockscreen="$1"
  local lockscreen="${XDG_CONFIG_HOME}/assets/current_lockscreen.png"

  convert \
    -gravity Center \
    -background "${bg}" \
    -resize "${dimensions}^" \
    -extent "${dimensions}" \
    "${new_lockscreen}" \
    "${lockscreen}"
}

main() {
  if [[ -f "${1:-}" ]]; then
    local new_lockscreen="$(realpath "$1")"
    create_lockscreen "${new_lockscreen}"
  fi
}

main "$@"
