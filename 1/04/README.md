### Домашнее задание

#### Работа с загрузчиком
##### 1. Попасть в систему без пароля несколькими способами

* способ № 1

В меню grub нажать `e`, и дописать `systemd.debug-shell` в строку `linux16` на x86-64 BIOS-based системах, или строку `linuxefi` на UEFI системах, нажать `^x`
После загрузки нажать `Alt+F9` или `Ctrl+Alt+F9` в зависимости от метода подключения.

Вы сразу попадёте в консоль под правами root.

* способ №2

В меню grub нажать `e`, и дописать `init=/sysroot/bin/sh` в строку `linux16` на x86-64 BIOS-based системах, или строку `linuxefi` на UEFI системах, нажать `^x`

![sysroot](https://i.imgur.com/0FyaScQ.png)

* способ № 3

В меню grub нажать `e`, и дописать `rd.break enforcing=0` в строку `linux16` на x86-64 BIOS-based системах, или строку `linuxefi` на UEFI системах. , нажать `^x`

![sysroot](https://i.imgur.com/nQryyRN.png)

Если используется selinux, после загрузки
```
restorecon /etc/shadow
```

* способ №4

Загузиться c live cd. Смонтировать нужную фс. Для смены пароля `chroot` и `passwd`

##### 2. Установить систему с LVM, после чего переименовать VG

Установлена centos 7 minimal
```
[root@home-10-0-2-15 ~]# df -h
Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/centos-root  7,8G  862M  6,5G  12% /
devtmpfs                 486M     0  486M   0% /dev
tmpfs                    497M     0  497M   0% /dev/shm
tmpfs                    497M  6,7M  490M   2% /run
tmpfs                    497M     0  497M   0% /sys/fs/cgroup
/dev/sda1                488M   93M  360M  21% /boot
/dev/mapper/centos-var   2,0G  134M  1,7G   8% /var
/dev/mapper/centos-home  988M  2,6M  919M   1% /home
tmpfs                    100M     0  100M   0% /run/user/0
```

```
# Переименовал vg
vgrename centos gentoo
  Volume group "centos" successfully renamed to "gentoo"

# обновил записи
sed -i "s/centos/gentoo/g" /etc/fstab
sed -i "s/centos/gentoo/g" /etc/grub/default
grub2-mkconfig -o /boot/grub2/grub.cfg

  # обновил initramfs
dracut -f /boot/initramfs-`uname -r`.img `uname -r`
```
Перезагрузка прошла успешно
```
 lvs
  LV   VG     Attr       LSize    Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home gentoo -wi-ao---- 1020,00m                                                    
  root gentoo -wi-ao----    8,00g                                                    
  swap gentoo -wi-ao----    1,00g                                                    
  var  gentoo -wi-ao----    2,00g  
```
##### 3. Добавить модуль в initrd
```
yum install mdadm -y
mkdir /usr/lib/dracut/modules.d/91local
cat  /usr/lib/dracut/modules.d/91local/module-setup.sh
#!/bin/bash

check() {
return 0
}

depends() {
return 0
}

install() {
inst_hook pre-trigger 91 "$moddir/mount-local.sh"
}

cat  /usr/lib/dracut/modules.d/91local/mount-local.sh
#!/bin/sh

mount_local()
{
mdadm -As
lvm pvscan
lvm vgscan
lvm lvscan
lvm vgchange -ay
}

mount_local
```
```
dracut -f /boot/initramfs-`uname -r`.img `uname -r`
```
