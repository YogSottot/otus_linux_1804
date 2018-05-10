#!/bin/bash
chroot /mnt/root/ /bin/bash -c "echo /dev/mapper/VolGroup01-root / ext4  defaults 0 0 > /etc/fstab ; \
echo /dev/mapper/VolGroup01-home /home ext4  defaults 0 0 >> /etc/fstab ; \
echo /dev/mapper/VolGroup01-swap swap swap defaults 0 0 >> /etc/fstab ; \
echo /dev/mapper/VolGroup01-var /var ext4  defaults 0 0 >> /etc/fstab ; \
find /etc/default/grub -type f -print0 | xargs -0 sed -i 's/GRUB_CMDLINE_LINUX/#GRUB_CMDLINE_LINUX/g' ; \
echo 'GRUB_CMDLINE_LINUX=\"no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 crashkernel=auto rd.lvm.lv=VolGroup01/root rd.lvm.lv=VolGroup01/var rd.lvm.lv=VolGroup01/home rd.lvm.lv=VolGroup01/swap selinux=0\"' >> /etc/default/grub ; \
cd /boot ; dracut -f initramfs-`uname -r`.img `uname -r` ; \
grub2-install  /dev/sdb ; \
grub2-install  /dev/sdc ; \
grub2-install  /dev/sdd ; \
grub2-install  /dev/sde ; \
grub2-mkconfig -o /boot/grub2/grub.cfg"
