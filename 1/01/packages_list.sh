#!/usr/bin/env bash

cd /usr/src/
curl https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.16.4.tar.xz | tar xJf -
cd linux-4.16.4/

yum install gcc -y
# Installing:
# gcc		x86_64    4.8.5-16.el7_4.2      updates       16 M
# Installing for dependencies:
# cpp		x86_64    4.8.5-16.el7_4.2      updates       6.0 M
# glibc-devel	x86_64    2.17-196.el7_4.2      updates       1.1 M
# glibc-headers  x86_64    2.17-196.el7_4.2      updates       676 k
# kernel-headers x86_64    3.10.0-693.21.1.el7   updates       6.0 M
# libmpc         x86_64    1.0.1-3.el7           base          51 k
# mpfr           x86_64    3.1.1-4.el7           base          203 k

yum install bison -y
# Installing:
#  bison          x86_64    3.0.4-1.el7           base          674 k
# Installing for dependencies:
#  m4             x86_64    1.4.16-10.el7         base          256 k

yum install flex -y
# Installing:
#  flex           x86_64    2.5.37-3.el7          base          292 k

yum install elfutils-libelf-devel -y
# Installing:
#  elfutils-libelf-devel		x86_64		0.168-8.el7	base	37 k
# Installing for dependencies:
#  zlib-devel			x86_64		1.2.7-17.el7	base	50 k

yum install bc -y
#  bc                             x86_64          1.06.95-13.el7  base    115 k

yum install openssl-devel -y
# Installing:
# openssl-devel                 x86_64           1:1.0.2k-8.el7  base    1.5 M
# Installing for dependencies:
# keyutils-libs-devel           x86_64           1.5.8-3.el7     base    37 k
# krb5-devel                    x86_64           1.15.1-8.el7    base    266 k
# libcom_err-devel              x86_64           1.42.9-10.el7   base    31 k
# libkadm5                      x86_64           1.15.1-8.el7    base    174 k
# libselinux-devel              x86_64           2.5-11.el7      base    186 k
# libsepol-devel                x86_64           2.5-6.el7       base    74 k
# libverto-devel                x86_64           0.2.5-4.el7     base    12 k
# pcre-devel                    x86_64           8.32-17.el7     base    480 k

yum install perl-devel -y
# Installing:
#  perl-devel                       x86_64           4:5.16.3-292.el7       base    453 k
# Installing for dependencies:
# gdbm-devel                        x86_64           1.10-8.el7             base    47 k
# libdb-devel                       x86_64           5.3.21-21.el7_4        updates 38 k
# perl                              x86_64           4:5.16.3-292.el7       base    8.0 M
# perl-Carp                         noarch           1.26-244.el7           base    19 k
# perl-Encode                       x86_64            2.51-7.el7             base    1.5 M
# perl-Exporter                     noarch           5.68-3.el7             base    28 k
# perl-ExtUtils-Install             noarch           1.58-292.el7           base    74 k
# perl-ExtUtils-MakeMaker           noarch           6.68-3.el7             base    275 k
# perl-ExtUtils-Manifest            noarch           1.61-244.el7           base    31 k
# perl-ExtUtils-ParseXS             noarch           1:3.18-3.el7           base    77 k
# perl-File-Path                    noarch           2.09-2.el7             base    26 k
# perl-File-Temp                    noarch           0.23.01-3.el7          base    56 k
# perl-Filter                       x86_64           1.49-3.el7             base    76 k
# perl-Getopt-Long                  noarch           2.40-2.el7             base    56 k
# perl-HTTP-Tiny                    noarch           0.033-3.el7            base    38 k
# perl-PathTools                    x86_64           3.40-5.el7             base    82 k
# perl-Pod-Escapes                  noarch           1:1.04-292.el7         base    51 k
# perl-Pod-Perldoc                  noarch           3.20-4.el7             base    87 k
# perl-Pod-Simple                   noarch           1:3.28-4.el7           base    216 k
# perl-Pod-Usage                    noarch           1.63-3.el7             base    27 k
# perl-Scalar-List-Utils            x86_64           1.27-248.el7           base    36 k
# perl-Socket                       x86_64           2.010-4.el7            base    49 k
# perl-Storable                     x86_64           2.45-3.el7             base    77 k
# perl-Test-Harness                 noarch           3.28-3.el7             base    302 k
# perl-Text-ParseWords              noarch           3.29-4.el7             base    14 k
# perl-Time-HiRes                   x86_64           4:1.9725-3.el7         base    45 k
# perl-Time-Local                   noarch           1.2300-2.el7           base    24 k
# perl-constant                     noarch           1.27-2.el7             base    19 k
# perl-libs                         x86_64           4:5.16.3-292.el7       base    688 k
# perl-macros                       x86_64           4:5.16.3-292.el7       base    43 k
# perl-parent                       noarch           1:0.225-244.el7        base    12 k
# perl-podlators                    noarch           2.5.1-3.el7            base    112 k
# perl-threads                      x86_64           1.87-4.el7             base    49 k
# perl-threads-shared               x86_64           1.43-6.el7             base    39 k
# pyparsing                         noarch           1.5.6-9.el7            base    94 k
# systemtap-sdt-devel               x86_64           3.1-5.el7_4            updates 71 k

# olddefconf ответит на все вопросы по умолчанию
cp /boot/config-`uname -r` .config && make olddefconfig && make prepare && make && make modules_install && make install && grub2-mkconfig -o /boot/grub2/grub.cfg

# manual reboot and select new kernel in virtbox
# uname -a
# Linux otuslinux 4.16.4 #1 SMP Wed Apr 25 10:36:56 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

