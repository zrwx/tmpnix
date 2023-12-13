#!/usr/bin/env bash
PS4="\e[34m[$(basename "${0}")"':${FUNCNAME[0]:+${FUNCNAME[0]}():}${LINENO:-}]: \e[0m'
IFS=$'\n\t'
set -euxo pipefail

die() {
  printf '%s\n' "${*}"
  exit 1
}

usage() {
  local program="$(basename "${0}")"
  local usage="$(cat \
<<EOF
usage:
  ${program} <encode> [<output_filename>]
  ${program} <decode>
EOF
  )"
  die "${usage}"
}

encode() {
  local input="${1:-$(cat)}"
  printf '%s' "${input}" \
    | qrencode --type=png --output=- \
    | xclip -selection clipboard -target image/png
}

decode() {
  zbarimg --raw --quiet <(maim --select --format=png)
}

main() {
  local verb="${1:-}"
  shift
  case "${verb}" in
    encode|decode) "${verb}" "$@" ;;
    *) usage ;;
  esac
}

main "$@"
