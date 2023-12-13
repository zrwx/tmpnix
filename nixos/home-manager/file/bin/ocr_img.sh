#!/usr/bin/env bash
PS4="\e[34m[$(basename "${0}")"':${FUNCNAME[0]:+${FUNCNAME[0]}():}${LINENO:-}]: \e[0m'
IFS=$'\n\t'
set -euo pipefail

img() {
  maim -s > "${1}"
}

ocr() {
  tesseract "${1}" -
}

main() {
  local target="$(mktemp '/tmp/tmp.XXX.png')"
  img "${target}"
  ocr "${target}"
  rm -f "${target}"
}

main "$@"
