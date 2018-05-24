#!/usr/bin/env bash

xargs -P 2 -I {} sh -c 'eval "$1"' - {} <<'EOF'
time dd if=/dev/urandom of=/mnt/swapfile55 bs=1M count=2048
time nice -n 19 ionice -c2 -n7 dd if=/dev/urandom of=/mnt/swapfile77 bs=1M count=2048
EOF
