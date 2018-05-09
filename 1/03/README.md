После применения Vagrant-файла, получаем  систему c LVM полностью готовую к загрузке.


Cделано в  vagrantfile:
* уменьшить том под / до 8G
* выделить том под /home 
* выделить том под /var 
* /var - сделать в mirror

Выжимки из vagrantfile
* разбивка диска на разделы
```
echo -e 'o\nn\n\n\n\n+2M\nn\n\n\n\n+512M\nn\n\n\n\n\na\n2\nw' | fdisk /dev/sdb  && \
```
создание lvm и разделов на нём
```
pvcreate /dev/sdb3 /dev/sdc /dev/sdd /dev/sde && \
vgcreate VolGroup01 /dev/sdb3 /dev/sdc /dev/sdd /dev/sde && \
lvcreate -L 1g VolGroup01 -n swap && \
lvcreate -L 8g VolGroup01 -n root && \
lvcreate -L 16g -m1 VolGroup01 -n var && \
lvcreate -L 8g VolGroup01 -n home && \
mkfs.ext4 /dev/VolGroup01/home && \
mkfs.ext4 /dev/VolGroup01/root && \
mkfs.ext4 /dev/VolGroup01/var && \
mkswap /dev/VolGroup01/swap && \
```
копирование системы со старого диска
```
mkdir -p /mnt/root && \
mount /dev/VolGroup01/root /mnt/root && \
rsync -aAHX  --exclude='/dev/**' --exclude='/proc/**' --exclude='/sys/**' --exclude='/boot/**' --exclude='/var/**' --exclude='/mnt/**' --exclude='/home/**' / /mnt/root/ ; \
mount /dev/VolGroup01/home /mnt/root/home/ && \
rsync -aAHX  /home/ /mnt/root/home/ ; \
mount /dev/VolGroup01/var /mnt/root/var && \
rsync -aAHX  /var/ /mnt/root/var/ ; \
mkfs.ext4 /dev/sdb2 && \
mount /dev/sdb2 /mnt/root/boot && \
rsync -aAHX /boot/  /mnt/root/boot/ ; \
mount -t proc /proc /mnt/root/proc ; \
mount --rbind /sys /mnt/root/sys ; \
mount --make-rslave /mnt/root/sys ; \
mount --rbind /dev /mnt/root/dev ; \
mount --make-rslave /mnt/root/dev 
```
* прописать монтирование в fstab

Выжимки из скрипта вызываемого из vagrantfile
```
chroot /mnt/root/ /bin/bash -c "echo UUID=`blkid -o value -s UUID /dev/sdb2` /boot ext4  defaults 0 0 > /etc/fstab  ; \ 
echo /dev/mapper/VolGroup01-root / ext4  defaults 0 0 >> /etc/fstab ; \
echo /dev/mapper/VolGroup01-home /home ext4  defaults 0 0 >> /etc/fstab ; \
echo /dev/mapper/VolGroup01-swap swap swap defaults 0 0 >> /etc/fstab ; \
echo /dev/mapper/VolGroup01-var /var ext4  defaults 0 0 >> /etc/fstab ; \
```
обновление информации в /etc/default/grub
```
find /etc/default/grub -type f -print0 | xargs -0 sed -i 's/GRUB_CMDLINE_LINUX/#GRUB_CMDLINE_LINUX/g' ; \
echo 'GRUB_CMDLINE_LINUX=\"no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 crashkernel=auto rd.lvm.lv=VolGroup01/root rd.lvm.lv=VolGroup01/var rd.lvm.lv=VolGroup01/home rd.lvm.lv=VolGroup01/swap selinux=0\"' >> /etc/default/grub ; \
```
генерация нового initrd
```
cd /boot ; dracut -f initramfs-`uname -r`.img ; \
```
установка загрузчика, обновление grub2.cfg
```
grub2-install  /dev/sdb ; \
grub2-mkconfig -o /boot/grub2/grub.cfg"
```


Загружаемся с новых дисков, отключив старый.
```
df -h
Filesystem                   Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup01-root  7.8G  580M  6.8G   8% /
devtmpfs                     489M     0  489M   0% /dev
tmpfs                        497M     0  497M   0% /dev/shm
tmpfs                        497M  6.6M  490M   2% /run
tmpfs                        497M     0  497M   0% /sys/fs/cgroup
/dev/mapper/VolGroup01-home  7.8G   37M  7.3G   1% /home
/dev/sda2                    488M   29M  424M   7% /boot
/dev/mapper/VolGroup01-var    16G   92M   15G   1% /var
tmpfs                        100M     0  100M   0% /run/user/1000
```
```
lvdisplay 
  --- Logical volume ---
  LV Path                /dev/VolGroup01/swap
  LV Name                swap
  VG Name                VolGroup01
  LV UUID                UweP31-dIWU-u0Tt-6xvh-JqA2-VGyB-WMnKuZ
  LV Write Access        read/write
  LV Creation host, time otuslinux, 2018-05-09 12:10:11 +0000
  LV Status              available
  # open                 2
  LV Size                1.00 GiB
  Current LE             256
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:7
   
  --- Logical volume ---
  LV Path                /dev/VolGroup01/root
  LV Name                root
  VG Name                VolGroup01
  LV UUID                XgwrNz-ZJyz-SrzS-AG4P-vuyJ-8cxR-9IbeT1
  LV Write Access        read/write
  LV Creation host, time otuslinux, 2018-05-09 12:10:12 +0000
  LV Status              available
  # open                 1
  LV Size                8.00 GiB
  Current LE             2048
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:0
   
  --- Logical volume ---
  LV Path                /dev/VolGroup01/var
  LV Name                var
  VG Name                VolGroup01
  LV UUID                Fxiq9C-yexN-6jes-Oev7-R3rk-iw1A-i3c7Pv
  LV Write Access        read/write
  LV Creation host, time otuslinux, 2018-05-09 12:10:12 +0000
  LV Status              available
  # open                 1
  LV Size                16.00 GiB
  Current LE             4096
  Mirrored volumes       2
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:5
   
  --- Logical volume ---
  LV Path                /dev/VolGroup01/home
  LV Name                home
  VG Name                VolGroup01
  LV UUID                Rq0Due-9y9X-ZgUj-H7Ag-PfK2-s7hy-qiq2Kb
  LV Write Access        read/write
  LV Creation host, time otuslinux, 2018-05-09 12:10:15 +0000
  LV Status              available
  # open                 1
  LV Size                8.00 GiB
  Current LE             2048
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:6
```

* сгенерить файлы в /home/
```
touch /home/test{0..10}
```
* снять снэпшот
```
lvcreate -L 1g -s -n home-backup /dev/VolGroup01/home
  Using default stripesize 64.00 KiB.
  Logical volume "home-backup" created.
```
* удалить часть файлов
```
rm -rf /home/test{0..5}
ls -l /home/
total 20
drwx------  2 root    root    16384 May  9 12:10 lost+found
-rw-r--r--  1 root    root        0 May  9 14:26 test10
-rw-r--r--  1 root    root        0 May  9 14:26 test6
-rw-r--r--  1 root    root        0 May  9 14:26 test7
-rw-r--r--  1 root    root        0 May  9 14:26 test8
-rw-r--r--  1 root    root        0 May  9 14:26 test9
drwx------. 3 vagrant vagrant  4096 May  9 14:24 vagrant

```
* восстановится со снэпшота
```
umount /home
lvconvert --merge /dev/VolGroup01/home-backup
Merging of volume /VolGroup01/home-backup started.
home: Merged: 100.00%
mount /home

ls -l /home/
total 20
drwx------  2 root    root    16384 May  9 14:43 lost+found
-rw-r--r--  1 root    root        0 May  9 14:53 test0
-rw-r--r--  1 root    root        0 May  9 14:53 test1
-rw-r--r--  1 root    root        0 May  9 14:53 test10
-rw-r--r--  1 root    root        0 May  9 14:53 test2
-rw-r--r--  1 root    root        0 May  9 14:53 test3
-rw-r--r--  1 root    root        0 May  9 14:53 test4
-rw-r--r--  1 root    root        0 May  9 14:53 test5
-rw-r--r--  1 root    root        0 May  9 14:53 test6
-rw-r--r--  1 root    root        0 May  9 14:53 test7
-rw-r--r--  1 root    root        0 May  9 14:53 test8
-rw-r--r--  1 root    root        0 May  9 14:53 test9
drwx------. 3 vagrant vagrant  4096 Apr  3 21:46 vagrant

```

