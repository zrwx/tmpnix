#!/usr/bin/env bash
PS4="\e[34m[$(basename "${0}")"':${FUNCNAME[0]:+${FUNCNAME[0]}():}${LINENO:-}]: \e[0m'
IFS=$'\n\t'
set -euxo pipefail

DISK=''
PART_BOOT=''
PART_LUKS=''
TYPE_GUID_BOOT='c12a7328-f81f-11d2-ba4b-00a0c93ec93b'
TYPE_GUID_LUKS='4f68bce3-e8cd-4db1-96e7-fbcaf984b709'
LABEL_BOOT='boot'
LABEL_LUKS='luks'
DISK_BOOT="/dev/disk/by-label/${LABEL_BOOT}"
DISK_LUKS="/dev/disk/by-label/${LABEL_LUKS}"
MNT='/mnt'
MNT_BOOT="${MNT}/boot"
MNT_YEET="${MNT}/yeet"
MNT_KEEP="${MNT}/keep"
MNT_NIX="${MNT}/nix"
ZFS_POOL='rpool'
ZFS_FS_YEET="${ZFS_POOL}/yeet"
ZFS_FS_KEEP="${ZFS_POOL}/yeet"
ZFS_FS_NIX="${ZFS_POOL}/nix"
ZFS_FS_YEET_SNAPSHOT="${ZFS_FS_YEET}@yeeted"

die() {
  if [[ "$#" -gt 0 ]]; then
    printf '\e[31m%s\e[0m\n' "${@}" >&2
  fi
  exit 1
}

assert_blockfile() {
  if [[ ! -b "${1:-}" ]]; then
    die "${FUNCNAME[0]}()"
  fi
}

partition() {
  sudo sgdisk --zap-all "${DISK}"
  sudo sgdisk --typecode="0:${TYPE_GUID_BOOT}" "${DISK}" --new='0:0:+1GiB'
  sudo sgdisk --typecode="0:${TYPE_GUID_LUKS}" "${DISK}" --new='0:0:' 
  local disks="$(lsblk -lpo 'NAME' | grep "${DISK}" | grep -v "^${DISK}$" | head -n 2)"
  PART_BOOT="$(printf '%s\n' "${disks}" | head -n 1)"
  PART_LUKS="$(printf '%s\n' "${disks}" | tail -n 1)"
  assert_blockfile "${PART_BOOT}"
  assert_blockfile "${PART_LUKS}"
  sudo partprobe "${DISK}"
}

format() {
  sudo mkfs.fat -F 32 -n "${LABEL_BOOT}" "${PART_BOOT}"
  sudo cryptsetup luksFormat --batch-mode --verify-passphrase --verbose --label "${LABEL_LUKS}" "${PART_LUKS}"
  sudo cryptsetup luksOpen "${PART_LUKS}" "${LABEL_LUKS}"
  sudo zpool create -O mountpoint=none rpool "/dev/mapper/${LABEL_LUKS}"
  sudo zfs create -p -o mountpoint=legacy "${ZFS_FS_YEET}"
  sudo zfs create -p -o mountpoint=legacy "${ZFS_FS_KEEP}"
  sudo zfs create -p -o mountpoint=legacy "${ZFS_FS_NIX}"
  sudo zfs snapshot "${ZFS_FS_YEET_SNAPSHOT}"
  sudo partprobe "${DISK}"
}

mount_disks() {
  sudo mount --mkdir --types zfs "${ZFS_FS_YEET}" "${MNT_YEET}"
  sudo mount --mkdir --types zfs "${ZFS_FS_KEEP}" "${MNT_KEEP}"
  sudo mount --mkdir --types zfs "${ZFS_FS_NIX}" "${MNT_NIX}"
  sudo mount --mkdir "${DISK_BOOT}" "${MNT_BOOT}"
}

install() {
  local flake='.#nixos'
  sudo nixos-rebuild boot --install-bootloader --verbose --show-trace --flake "${flake}"
}

main() {
  DISK="${1:-}"
  assert_blockfile "${DISK}"
  partition
  format
  mount_disks
  install
}

main "$@"
