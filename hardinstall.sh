#!/usr/bin/env bash
PS4="\e[34m[$(basename "${0}")"':${FUNCNAME[0]:+${FUNCNAME[0]}():}${LINENO:-}]: \e[0m'
IFS=$'\n\t'
set -euxo pipefail

DISK=''
BOOT_PART=''
ROOT_PART=''
BOOT_PART_NAME='Boot Partition'
ROOT_PART_NAME='Root Partition'
BOOT_PART_TYPE_GUID='c12a7328-f81f-11d2-ba4b-00a0c93ec93b'
ROOT_PART_TYPE_GUID='4f68bce3-e8cd-4db1-96e7-fbcaf984b709'
LABEL_BOOT='boot'
LABEL_ROOT='root'
LABEL_LUKS='luks'
POOL='rpool'
MNT='/mnt'

die() {
  if [[ "$#" -gt 0 ]]; then
    printf '\e[31m%s\e[0m\n' "${@}" >&2
  fi
  exit 1
}

assert_blockfile() {
  if [[ "$#" != 1 || ! -b "${1}" || "${1}" == '/dev' ]]; then
    die "${FUNCNAME[0]}()"
  fi
}

partition() {
  if [[ "$#" -lt 1 ]]; then
    die "${FUNCNAME[0]}(): invalid argc"
  fi

  DISK="${1}"
  assert_blockfile "${DISK}"

  sudo sgdisk --zap-all "${DISK}"
  sudo sgdisk --new='0:0:+1GiB' --change-name="0:${BOOT_PART_NAME}" --typecode="0:${BOOT_PART_TYPE_GUID}" "${DISK}"
  sudo sgdisk --new='0:0:' --change-name="0:${ROOT_PART_NAME}" --typecode="0:${ROOT_PART_TYPE_GUID}" "${DISK}"

  sudo partprobe "${DISK}"

  local partitions="$(lsblk -l "${DISK}" | grep part | cut -d ' ' -f 1 | head -n 2)"

  BOOT_PART="/dev/$(head -n 1 <<< "${partitions}")"
  ROOT_PART="/dev/$(tail -n 1 <<< "${partitions}")"

  assert_blockfile "${BOOT_PART}"
  assert_blockfile "${ROOT_PART}"

  if [[ "${BOOT_PART}" == "${ROOT_PART}" ]]; then
    die "${FUNCNAME[0]}(): failed to create two partitions"
  fi
}

format() {
  sudo mkfs.fat -F 32 -n "${LABEL_BOOT}" "${BOOT_PART}"
  sudo cryptsetup luksFormat --batch-mode --verify-passphrase --verbose --label "${LABEL_LUKS}" "${ROOT_PART}"
  sudo cryptsetup luksOpen "${ROOT_PART}" "${LABEL_LUKS}"

  zfs_create() {
    sudo zfs create -p -o mountpoint=legacy "${POOL}/${1}"
  }

  sudo zpool create -O mountpoint=none rpool "/dev/mapper/${LABEL_LUKS}"
  zfs_create yeet
  zfs_create keep
  zfs_create nix
  sudo zfs snapshot "${POOL}/yeet@yeeted"
}

mount_disks() {
  mount_zfs() {
    sudo mount --mkdir --types zfs "${POOL}/${1}" "${2}"
  }

  mount_zfs local/root /mnt
  mount_zfs local/nix /mnt/nix
  mount_zfs safe/home /mnt/home
  mount_zfs safe/persist /mnt/persist

  sudo mount --mkdir /dev/disk/by-label/boot /mnt/boot
  # sudo mount --mkdir "/dev/disk/by-label/${LABEL_ROOT}" '/mnt'
  # sudo mount --mkdir "/dev/disk/by-label/${LABEL_BOOT}" '/mnt/boot'
}

install() {
  local flake='.#u'
  sudo nixos-install --install-bootloader --verbose --show-trace --flake "${flake}"
}

main() {
  # if [[ "${#}" != '1' ]]; then
  #   die 'argc != 1, no disk passed'
  # fi
  # local disk="${1}"
  # partition "${disk}"
  # format
  # sudo partprobe "${DISK}"
  mount_disks
  # install
}

main "$@"
