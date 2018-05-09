#!/bin/bash
cat <<\EOT >> /etc/yum.repos.d/grub.repo
[grub]
name=grub lvm
baseurl=https://yum.rumyantsev.com/centos/$releasever/$basearch/
enabled=1
gpgcheck=0
EOT
