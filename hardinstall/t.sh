#!/usr/bin/env bash
PS4="\e[34m[$(basename "${0}")"':${FUNCNAME[0]:+${FUNCNAME[0]}():}${LINENO:-}]: \e[0m'
IFS=$'\n\t'
set -euo pipefail
set -x

die() {
  if [[ "$#" -gt 0 ]]; then
    printf '\e[31m%s\e[0m\n' "${@}" >&2
  fi
  exit 1
}

main() {
  local disko='./disko.nix'
  local disks='[ "/dev/sda" ]'

  sudo rsync secret.txt /tmp

  sudo nix run github:nix-community/disko \
    --experimental-features 'nix-command flakes' \
    -- \
    --mode disko "${disko}" \
    --arg disks "${disks}"
}

main "$@"
