### Домашнее задание
#### Работа с загрузчиком (*)
##### 3. Сконфигурировать систему без отдельного раздела с /boot, а только с LVM

За основу взят vagrantfile из ДЗ 1.3

Всё происходит автоматически через vagrantfile

Добавление репозитория
```
cat /vagrant/repo.sh
#!/bin/bash
cat <<\EOT >> /etc/yum.repos.d/grub.repo
[grub]
name=grub lvm
baseurl=https://yum.rumyantsev.com/centos/$releasever/$basearch/
enabled=1
gpgcheck=0
EOT

```
Обновление grub2
```
yum update grub2
```

создание lvm 
```
pvcreate --bootloaderareasize 1m /dev/sdb /dev/sdc /dev/sdd /dev/sde && \
vgcreate VolGroup01 /dev/sdb /dev/sdc /dev/sdd /dev/sde && \
lvcreate -L 1g VolGroup01 -n swap && \
lvcreate -L 8g VolGroup01 -n root && \
lvcreate -L 16g VolGroup01 -n var && \
lvcreate -L 8g VolGroup01 -n home && \
```
создание fs
```
mkfs.ext4 /dev/VolGroup01/home && \
mkfs.ext4 /dev/VolGroup01/root && \
mkfs.ext4 /dev/VolGroup01/var && \
mkswap /dev/VolGroup01/swap && \
```
копирование системы со старого диска на новые
```
mkdir -p /mnt/root && \
mount /dev/VolGroup01/root /mnt/root && \
rsync -aAHX  --exclude='/dev/**' --exclude='/proc/**' --exclude='/sys/**' --exclude='/var/**' --exclude='/mnt/**' --exclude='/home/**' / /mnt/root/ ; \
mount /dev/VolGroup01/home /mnt/root/home/ && \
rsync -aAHX  /home/ /mnt/root/home/ ; \
mount /dev/VolGroup01/var /mnt/root/var && \
rsync -aAHX  /var/ /mnt/root/var/ ; \
mount -t proc /proc /mnt/root/proc ; \
mount --rbind /sys /mnt/root/sys ; \
mount --make-rslave /mnt/root/sys ; \
mount --rbind /dev /mnt/root/dev ; \
mount --make-rslave /mnt/root/dev ; \
/bin/bash /vagrant/chroot.sh
```
установка grub на все диски.
```
cat /vagrant/chroot.sh
#!/bin/bash
chroot /mnt/root/ /bin/bash -c "echo /dev/mapper/VolGroup01-root / ext4  defaults 0 0 >> /etc/fstab ; \
echo /dev/mapper/VolGroup01-home /home ext4  defaults 0 0 >> /etc/fstab ; \
echo /dev/mapper/VolGroup01-swap swap swap defaults 0 0 >> /etc/fstab ; \
echo /dev/mapper/VolGroup01-var /var ext4  defaults 0 0 >> /etc/fstab ; \
find /etc/default/grub -type f -print0 | xargs -0 sed -i 's/GRUB_CMDLINE_LINUX/#GRUB_CMDLINE_LINUX/g' ; \
echo 'GRUB_CMDLINE_LINUX=\"no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 crashkernel=auto rd.lvm.lv=VolGroup01/root rd.lvm.lv=VolGroup01/var rd.lvm.lv=VolGroup01/home rd.lvm.lv=VolGroup01/swap selinux=0\"' >> /etc/default/grub ; \
cd /boot ; dracut -f initramfs-`uname -r`.img `uname -r`; \
grub2-install  /dev/sdb ; \
grub2-install  /dev/sdc ; \
grub2-install  /dev/sdd ; \
grub2-install  /dev/sde ; \
grub2-mkconfig -o /boot/grub2/grub.cfg"
```

Отключаю старый диск и загружаюсь.

```
cat /etc/fstab
menuentry 'CentOS Linux (3.10.0-693.21.1.el7.x86_64) 7 (Core)' --class centos --class gnu-linux --class gnu --class os --unrestricted $menuentry_id_option 'gnulinux-3.10.0-693.21.1.el7.x86_64-advanced-10914d08-60c1-4a32-86b7-c1a09b6cfd23' {
        load_video
        set gfxpayload=keep
        insmod gzio
        insmod lvm
        insmod ext2
        set root='lvmid/Kkw52F-7pIS-CrkP-tsfa-u2M3-aOeY-BiKLzu/SdlBZn-gzAb-kzI3-YCdX-gvCK-2hA0-0rI1hb'
        if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root --hint='lvmid/Kkw52F-7pIS-CrkP-tsfa-u2M3-aOeY-BiKLzu/SdlBZn-gzAb-kzI3-YCdX-gvCK-2hA0-0rI1hb'  10914d08-60c1-4a32-86b7-c1a09b6cfd23
        else
          search --no-floppy --fs-uuid --set=root 10914d08-60c1-4a32-86b7-c1a09b6cfd23
        fi
        linux16 /boot/vmlinuz-3.10.0-693.21.1.el7.x86_64 root=/dev/mapper/VolGroup01-root ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 crashkernel=auto rd.lvm.lv=VolGroup01/root rd.lvm.lv=VolGroup01/var rd.lvm.lv=VolGroup01/home rd.lvm.lv=VolGroup01/swap selinux=0 
        initrd16 /boot/initramfs-3.10.0-693.21.1.el7.x86_64.img

```
