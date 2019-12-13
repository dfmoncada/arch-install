# not sure
# timedatectl set-ntp true

# create partitions and format them
# normal distribution
# use gpd
# /boot /efi 250M         EFI
# /          20% < 80G    Linux Root
# /swap      2G           Linux Swap
# /home      rest         Linux home
cfdisk

mkfs.fat -F32 /dev/dsa1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda4

mkswap /dev/sda3
swapon /dev/sda3

# mount partitions
mount /dev/sda2 /mnt

mkdir /mnt/efi
mkdir /mnt/home
mount /dev/sda1 /mnt/efi
mount /dev/sda4 /mnt/home

# install base
pacstrap /mnt base base-devel linux linux-firmware vim grub efibootmgr sudo

# create fstab
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

## IN ARCH new system AS ROOT
## NEW SHELL SCRIPT 
ln -sf /usr/share/zoneinfo/Chile/Continental /etc/locale
hwclock --systohc

# language 
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
localge-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# skipping network conf since I believe is not crucial at the time

# create initramfs. usually runs at pacstrap
# mkinitcpio -P 

# change root pass
passwd
useradd -mg users -G wheel,storage,power -s /bin/bash diego
visudo 
passwd diego

# boot loader
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
