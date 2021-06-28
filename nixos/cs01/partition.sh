# /bin/sh
parted --script /dev/sda \
    mklabel gpt \
    mkpart ESP 1MiB 512MiB \
    set 1 esp on \
    mkpart primary 512MiB 100%

cryptsetup luksFormat /dev/sda2
cryptsetup luksOpen /dev/sda2 nixos-enc
mkfs.btrfs -L nixos /dev/mapper/nixos-enc
mkfs.fat -F 32 -n boot /dev/sda1
mount /dev/mapper/nixos-enc /mnt/
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot/