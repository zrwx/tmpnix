#!/usr/bin/env bash
PS4="\e[34m[${0:-}:\${LINENO:-}]: \e[0m"
IFS=$'\n\t'
set -euxo pipefail

main() {
  local assets_dir="${XDG_CONFIG_HOME}/assets"
  mkdir -p "${assets_dir}"
  local background="${assets_dir}/current_background.png"
  local lockscreen="${assets_dir}/current_background.png"

  if [[ "$#" -gt 0 && -f "$1" ]]; then
    local new_background="$(realpath "$1")"
    convert "${new_background}" -resize 2560x1440 "${background}"
  fi

  xwallpaper --zoom "${background}"
}

main "$@"
