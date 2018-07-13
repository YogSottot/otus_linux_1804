#!/usr/bin/env bash

ssh vagrant@192.168.255.1
nmap -Pn --host_timeout 100 --max-retries 0 -p 8991 192.168.255.1
nmap -Pn --host_timeout 100 --max-retries 0 -p 7766 192.168.255.1
nmap -Pn --host_timeout 100 --max-retries 0 -p 5591 192.168.255.1
ssh vagrant@192.168.255.1
