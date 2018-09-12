### Домашнее задание
#### простая связь через pjsip

- **установить астериск на сервере**  
для установки воспользоваться ролью https://github.com/erlong15/tls-asterisk14-ansible  

при установке создаются 3 номер 1100, 1101, 1102  
подключить два телефона (можно использовать transport-tls, transport-udp, transport-tcp)  
сделать звонок  
в качестве ДЗ принимается лог SIP сессии  

Для запуска zoiper использован x11 forwarding.  

Для установки zoiper, нужно скачать zoiper5_5.2.19_x86_64.rpm и разместить его рядом с Vagrantfile

```
config.ssh.forward_x11 = true  
```
```bash
ssh -i .vagrant/machines/slave1/virtualbox/private_key -X -p 2200 vagrant@localhost zoiper5
ssh -i .vagrant/machines/slave2/virtualbox/private_key -X -p 2201 vagrant@localhost zoiper5
```
```bash
MariaDB [asterisk]> select * from ps_auths;
+------+-----------+----------------+----------+------------+-------+----------+
| id   | auth_type | nonce_lifetime | md5_cred | password   | realm | username |
+------+-----------+----------------+----------+------------+-------+----------+
| 1100 | userpass  |           NULL | NULL     | 16032528   | NULL  | 1100     |
| 1101 | userpass  |           NULL | NULL     | 139693809  | NULL  | 1101     |
| 1102 | userpass  |           NULL | NULL     | 2251423599 | NULL  | 1102     |
+------+-----------+----------------+----------+------------+-------+----------+
3 rows in set (0.00 sec)
```
```bash
master*CLI> pjsip list contacts

  Contact:  <Aor/ContactUri..............................> <Hash....> <Status> <RTT(ms)..>
==========================================================================================

  Contact:  1101/sip:1101@192.168.100.11:64565;rinstance=1 13e094a723 Unknown         nan
  Contact:  1102/sip:1102@192.168.100.12:60773;rinstance=b 3e95713ce5 Unknown         nan

Objects found: 2

```

```bash
master*CLI> pjsip set logger on
PJSIP Logging enabled
master*CLI> core set debug 9
Core debug is still 9.
master*CLI> core set verbose 9
Console verbose was 4 and is now 9.
<--- Received SIP request (1174 bytes) from UDP:192.168.100.12:60773 --->
INVITE sip:1101@192.168.100.10;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 192.168.100.12:60773;branch=z9hG4bK-524287-1---674d4ad549442c91
Max-Forwards: 70
Contact: <sip:1102@192.168.100.12:60773;transport=UDP>
To: <sip:1101@192.168.100.10;transport=UDP>
From: <sip:1102@192.168.100.10;transport=UDP>;tag=9480006f
Call-ID: vAS_mOFDoAoDYkDQC2-3nw..
CSeq: 1 INVITE
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
Content-Type: application/sdp
User-Agent: Z 5.2.19 rv2.8.99
Allow-Events: presence, kpml, talk
Content-Length: 604

v=0
o=Z 0 0 IN IP4 192.168.100.12
s=Z
c=IN IP4 192.168.100.12
t=0 0
m=audio 8000 RTP/AVP 9 106 3 111 0 8 97 110 112 101 98 100 99 102
a=rtpmap:106 opus/48000/2
a=fmtp:106 minptime=20; cbr=1; maxaveragebitrate=40000; useinbandfec=1
a=rtpmap:111 speex/16000
a=rtpmap:97 iLBC/8000
a=fmtp:97 mode=20
a=rtpmap:110 speex/8000
a=rtpmap:112 speex/32000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
a=rtpmap:98 telephone-event/48000
a=fmtp:98 0-16
a=rtpmap:100 telephone-event/16000
a=fmtp:100 0-16
a=rtpmap:99 telephone-event/32000
a=fmtp:99 0-16
a=rtpmap:102 G726-32/8000
a=sendrecv

<--- Transmitting SIP response (510 bytes) to UDP:192.168.100.12:60773 --->
SIP/2.0 401 Unauthorized
Via: SIP/2.0/UDP 192.168.100.12:60773;rport=60773;received=192.168.100.12;branch=z9hG4bK-524287-1---674d4ad549442c91
Call-ID: vAS_mOFDoAoDYkDQC2-3nw..
From: <sip:1102@192.168.100.10>;tag=9480006f
To: <sip:1101@192.168.100.10>;tag=z9hG4bK-524287-1---674d4ad549442c91
CSeq: 1 INVITE
WWW-Authenticate: Digest  realm="asterisk",nonce="1536747481/da7497c5714dc8d1307ec3f773a5e121",opaque="283dd1d9643e4cf8",algorithm=md5,qop="auth"
Server: Asterisk PBX 14.7.7
Content-Length:  0


<--- Received SIP request (351 bytes) from UDP:192.168.100.12:60773 --->
ACK sip:1101@192.168.100.10;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 192.168.100.12:60773;branch=z9hG4bK-524287-1---674d4ad549442c91
Max-Forwards: 70
To: <sip:1101@192.168.100.10>;tag=z9hG4bK-524287-1---674d4ad549442c91
From: <sip:1102@192.168.100.10;transport=UDP>;tag=9480006f
Call-ID: vAS_mOFDoAoDYkDQC2-3nw..
CSeq: 1 ACK
Content-Length: 0


<--- Received SIP request (1473 bytes) from UDP:192.168.100.12:60773 --->
INVITE sip:1101@192.168.100.10;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 192.168.100.12:60773;branch=z9hG4bK-524287-1---2e91df7b4228e515
Max-Forwards: 70
Contact: <sip:1102@192.168.100.12:60773;transport=UDP>
To: <sip:1101@192.168.100.10;transport=UDP>
From: <sip:1102@192.168.100.10;transport=UDP>;tag=9480006f
Call-ID: vAS_mOFDoAoDYkDQC2-3nw..
CSeq: 2 INVITE
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
Content-Type: application/sdp
User-Agent: Z 5.2.19 rv2.8.99
Authorization: Digest username="1102",realm="asterisk",nonce="1536747481/da7497c5714dc8d1307ec3f773a5e121",uri="sip:1101@192.168.100.10;transport=UDP",response="b32ca8893e730c09ac3345b998829343",cnonce="d558da31649f85c064f90d9124aad0e2",nc=00000001,qop=auth,algorithm=md5,opaque="283dd1d9643e4cf8"
Allow-Events: presence, kpml, talk
Content-Length: 604

v=0
o=Z 0 0 IN IP4 192.168.100.12
s=Z
c=IN IP4 192.168.100.12
t=0 0
m=audio 8000 RTP/AVP 9 106 3 111 0 8 97 110 112 101 98 100 99 102
a=rtpmap:106 opus/48000/2
a=fmtp:106 minptime=20; cbr=1; maxaveragebitrate=40000; useinbandfec=1
a=rtpmap:111 speex/16000
a=rtpmap:97 iLBC/8000
a=fmtp:97 mode=20
a=rtpmap:110 speex/8000
a=rtpmap:112 speex/32000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
a=rtpmap:98 telephone-event/48000
a=fmtp:98 0-16
a=rtpmap:100 telephone-event/16000
a=fmtp:100 0-16
a=rtpmap:99 telephone-event/32000
a=fmtp:99 0-16
a=rtpmap:102 G726-32/8000
a=sendrecv

  == Setting global variable 'SIPDOMAIN' to '192.168.100.10'
<--- Transmitting SIP response (317 bytes) to UDP:192.168.100.12:60773 --->
SIP/2.0 100 Trying
Via: SIP/2.0/UDP 192.168.100.12:60773;rport=60773;received=192.168.100.12;branch=z9hG4bK-524287-1---2e91df7b4228e515
Call-ID: vAS_mOFDoAoDYkDQC2-3nw..
From: <sip:1102@192.168.100.10>;tag=9480006f
To: <sip:1101@192.168.100.10>
CSeq: 2 INVITE
Server: Asterisk PBX 14.7.7
Content-Length:  0


    -- Executing [1101@default:1] Dial("PJSIP/1102-00000000", "PJSIP/1101") in new stack
    -- Called PJSIP/1101
<--- Transmitting SIP request (1021 bytes) to UDP:192.168.100.11:64565 --->
INVITE sip:1101@192.168.100.11:64565;rinstance=c41238c9fa63c32e SIP/2.0
Via: SIP/2.0/UDP 192.168.100.10:5060;rport;branch=z9hG4bKPj8c99c754-a79c-4ef1-9749-ff5a98f36e28
From: <sip:1102@10.0.2.15>;tag=4fbeb581-74f7-418a-9b4a-bb977fb563e4
To: <sip:1101@192.168.100.11;rinstance=c41238c9fa63c32e>
Contact: <sip:asterisk@192.168.100.10:5060>
Call-ID: 1b58673a-23e2-4f12-9514-861f1a7e21fc
CSeq: 6509 INVITE
Allow: OPTIONS, SUBSCRIBE, NOTIFY, PUBLISH, INVITE, ACK, BYE, CANCEL, UPDATE, PRACK, REGISTER, MESSAGE, REFER
Supported: 100rel, timer, replaces, norefersub
Session-Expires: 1800
Min-SE: 90
Max-Forwards: 70
User-Agent: Asterisk PBX 14.7.7
Content-Type: application/sdp
Content-Length:   312

v=0
o=- 1791768709 1791768709 IN IP4 192.168.100.10
s=Asterisk
c=IN IP4 192.168.100.10
t=0 0
m=audio 20716 RTP/AVP 8 0 3 9 101
a=rtpmap:8 PCMA/8000
a=rtpmap:0 PCMU/8000
a=rtpmap:3 GSM/8000
a=rtpmap:9 G722/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
a=ptime:20
a=maxptime:150
a=sendrecv

<--- Received SIP response (336 bytes) from UDP:192.168.100.11:64565 --->
SIP/2.0 100 Trying
Via: SIP/2.0/UDP 192.168.100.10:5060;rport=5060;branch=z9hG4bKPj8c99c754-a79c-4ef1-9749-ff5a98f36e28
To: <sip:1101@192.168.100.11;rinstance=c41238c9fa63c32e>
From: <sip:1102@10.0.2.15>;tag=4fbeb581-74f7-418a-9b4a-bb977fb563e4
Call-ID: 1b58673a-23e2-4f12-9514-861f1a7e21fc
CSeq: 6509 INVITE
Content-Length: 0


<--- Received SIP response (542 bytes) from UDP:192.168.100.11:64565 --->
SIP/2.0 180 Ringing
Via: SIP/2.0/UDP 192.168.100.10:5060;rport=5060;branch=z9hG4bKPj8c99c754-a79c-4ef1-9749-ff5a98f36e28
Contact: <sip:1101@192.168.100.11:64565>
To: <sip:1101@192.168.100.11;rinstance=c41238c9fa63c32e>;tag=aa1f1707
From: <sip:1102@10.0.2.15>;tag=4fbeb581-74f7-418a-9b4a-bb977fb563e4
Call-ID: 1b58673a-23e2-4f12-9514-861f1a7e21fc
CSeq: 6509 INVITE
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
User-Agent: Z 5.2.19 rv2.8.99
Allow-Events: presence, kpml, talk
Content-Length: 0


    -- PJSIP/1101-00000001 is ringing
<--- Transmitting SIP response (506 bytes) to UDP:192.168.100.12:60773 --->
SIP/2.0 180 Ringing
Via: SIP/2.0/UDP 192.168.100.12:60773;rport=60773;received=192.168.100.12;branch=z9hG4bK-524287-1---2e91df7b4228e515
Call-ID: vAS_mOFDoAoDYkDQC2-3nw..
From: <sip:1102@192.168.100.10>;tag=9480006f
To: <sip:1101@192.168.100.10>;tag=dab28d84-1b8e-49f0-8a97-9cc960ae3ede
CSeq: 2 INVITE
Server: Asterisk PBX 14.7.7
Contact: <sip:192.168.100.10:5060>
Allow: OPTIONS, SUBSCRIBE, NOTIFY, PUBLISH, INVITE, ACK, BYE, CANCEL, UPDATE, PRACK, REGISTER, MESSAGE, REFER
Content-Length:  0


<--- Received SIP response (1239 bytes) from UDP:192.168.100.11:64565 --->
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.100.10:5060;rport=5060;branch=z9hG4bKPj8c99c754-a79c-4ef1-9749-ff5a98f36e28
Require: timer
Contact: <sip:1101@192.168.100.11:64565>
To: <sip:1101@192.168.100.11;rinstance=c41238c9fa63c32e>;tag=aa1f1707
From: <sip:1102@10.0.2.15>;tag=4fbeb581-74f7-418a-9b4a-bb977fb563e4
Call-ID: 1b58673a-23e2-4f12-9514-861f1a7e21fc
CSeq: 6509 INVITE
Session-Expires: 1800;refresher=uac
Min-SE: 90
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
Content-Type: application/sdp
User-Agent: Z 5.2.19 rv2.8.99
Allow-Events: presence, kpml, talk
Content-Length: 604

v=0
o=Z 0 1 IN IP4 192.168.100.11
s=Z
c=IN IP4 192.168.100.11
t=0 0
m=audio 8000 RTP/AVP 8 9 106 3 111 0 97 110 112 102 101 98 100 99
a=rtpmap:106 opus/48000/2
a=fmtp:106 minptime=20; cbr=1; maxaveragebitrate=40000; useinbandfec=1
a=rtpmap:111 speex/16000
a=rtpmap:97 iLBC/8000
a=fmtp:97 mode=20
a=rtpmap:110 speex/8000
a=rtpmap:112 speex/32000
a=rtpmap:102 G726-32/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
a=rtpmap:98 telephone-event/48000
a=fmtp:98 0-16
a=rtpmap:100 telephone-event/16000
a=fmtp:100 0-16
a=rtpmap:99 telephone-event/32000
a=fmtp:99 0-16
a=sendrecv

       > 0x2648ed0 -- Strict RTP learning after remote address set to: 192.168.100.11:8000
<--- Transmitting SIP request (416 bytes) to UDP:192.168.100.11:64565 --->
ACK sip:1101@192.168.100.11:64565 SIP/2.0
Via: SIP/2.0/UDP 192.168.100.10:5060;rport;branch=z9hG4bKPj5c480bb4-dd87-4ba9-917f-78acf8859fcf
From: <sip:1102@10.0.2.15>;tag=4fbeb581-74f7-418a-9b4a-bb977fb563e4
To: <sip:1101@192.168.100.11;rinstance=c41238c9fa63c32e>;tag=aa1f1707
Call-ID: 1b58673a-23e2-4f12-9514-861f1a7e21fc
CSeq: 6509 ACK
Max-Forwards: 70
User-Agent: Asterisk PBX 14.7.7
Content-Length:  0


    -- PJSIP/1101-00000001 answered PJSIP/1102-00000000
       > 0x26c6560 -- Strict RTP learning after remote address set to: 192.168.100.12:8000
<--- Transmitting SIP response (877 bytes) to UDP:192.168.100.12:60773 --->
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.100.12:60773;rport=60773;received=192.168.100.12;branch=z9hG4bK-524287-1---2e91df7b4228e515
Call-ID: vAS_mOFDoAoDYkDQC2-3nw..
From: <sip:1102@192.168.100.10>;tag=9480006f
To: <sip:1101@192.168.100.10>;tag=dab28d84-1b8e-49f0-8a97-9cc960ae3ede
CSeq: 2 INVITE
Server: Asterisk PBX 14.7.7
Allow: OPTIONS, SUBSCRIBE, NOTIFY, PUBLISH, INVITE, ACK, BYE, CANCEL, UPDATE, PRACK, REGISTER, MESSAGE, REFER
Contact: <sip:192.168.100.10:5060>
Supported: 100rel, timer, replaces, norefersub
Content-Type: application/sdp
Content-Length:   294

v=0
o=- 0 2 IN IP4 192.168.100.10
s=Asterisk
c=IN IP4 192.168.100.10
t=0 0
m=audio 24150 RTP/AVP 8 0 3 9 101
a=rtpmap:8 PCMA/8000
a=rtpmap:0 PCMU/8000
a=rtpmap:3 GSM/8000
a=rtpmap:9 G722/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
a=ptime:20
a=maxptime:150
a=sendrecv

    -- Channel PJSIP/1101-00000001 joined 'simple_bridge' basic-bridge <e9d3bf79-2d3f-42f3-ae8e-24781dae1410>
       > 0x2648ed0 -- Strict RTP switching to RTP target address 192.168.100.11:8000 as source
Got  RTP packet from    192.168.100.11:8000 (type 95, seq 033254, ts 2916527478, len 000001)
    -- Channel PJSIP/1102-00000000 joined 'simple_bridge' basic-bridge <e9d3bf79-2d3f-42f3-ae8e-24781dae1410>
       > Bridge e9d3bf79-2d3f-42f3-ae8e-24781dae1410: switching from simple_bridge technology to native_rtp
       > Locally RTP bridged 'PJSIP/1102-00000000' and 'PJSIP/1101-00000001' in stack
Sent RTP P2P packet to 192.168.100.12:8000 (type 08, len 000160)
       > 0x26c6560 -- Strict RTP switching to RTP target address 192.168.100.12:8000 as source
Got  RTP packet from    192.168.100.12:8000 (type 95, seq 064312, ts 4280519223, len 000001)
<--- Received SIP request (411 bytes) from UDP:192.168.100.12:60773 --->
ACK sip:192.168.100.10:5060 SIP/2.0
Via: SIP/2.0/UDP 192.168.100.12:60773;branch=z9hG4bK-524287-1---d345166dcc150bed
Max-Forwards: 70
Contact: <sip:1102@192.168.100.12:60773;transport=UDP>
To: <sip:1101@192.168.100.10>;tag=dab28d84-1b8e-49f0-8a97-9cc960ae3ede
From: <sip:1102@192.168.100.10>;tag=9480006f
Call-ID: vAS_mOFDoAoDYkDQC2-3nw..
CSeq: 2 ACK
User-Agent: Z 5.2.19 rv2.8.99
Content-Length: 0


Sent RTP P2P packet to 192.168.100.12:8000 (type 08, len 000160)
Sent RTP P2P packet to 192.168.100.11:8000 (type 08, len 000160)
Sent RTP P2P packet to 192.168.100.12:8000 (type 08, len 000160)
Sent RTP P2P packet to 192.168.100.11:8000 (type 08, len 000160)
Sent RTP P2P packet to 192.168.100.12:8000 (type 08, len 000160)
       > 0x26c6560 -- Strict RTP learning complete - Locking on source address 192.168.100.12:8000
Sent RTP P2P packet to 192.168.100.11:8000 (type 08, len 000160)
       > 0x2648ed0 -- Strict RTP learning complete - Locking on source address 192.168.100.11:8000
Sent RTP P2P packet to 192.168.100.12:8000 (type 08, len 000160)
Sent RTP P2P packet to 192.168.100.11:8000 (type 08, len 000160)
Sent RTP P2P packet to 192.168.100.12:8000 (type 08, len 000160)
Sent RTP P2P packet to 192.168.100.11:8000 (type 08, len 000160)
<--- Received SIP request (440 bytes) from UDP:192.168.100.11:64565 --->
BYE sip:asterisk@192.168.100.10:5060 SIP/2.0
Via: SIP/2.0/UDP 192.168.100.11:64565;branch=z9hG4bK-524287-1---151527d5382f743b
Max-Forwards: 70
Contact: <sip:1101@192.168.100.11:64565>
To: <sip:1102@10.0.2.15>;tag=4fbeb581-74f7-418a-9b4a-bb977fb563e4
From: <sip:1101@192.168.100.11;rinstance=c41238c9fa63c32e>;tag=aa1f1707
Call-ID: 1b58673a-23e2-4f12-9514-861f1a7e21fc
CSeq: 2 BYE
User-Agent: Z 5.2.19 rv2.8.99
Content-Length: 0


<--- Transmitting SIP response (385 bytes) to UDP:192.168.100.11:64565 --->
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.100.11:64565;rport=64565;received=192.168.100.11;branch=z9hG4bK-524287-1---151527d5382f743b
Call-ID: 1b58673a-23e2-4f12-9514-861f1a7e21fc
From: <sip:1101@192.168.100.11;rinstance=c41238c9fa63c32e>;tag=aa1f1707
To: <sip:1102@10.0.2.15>;tag=4fbeb581-74f7-418a-9b4a-bb977fb563e4
CSeq: 2 BYE
Server: Asterisk PBX 14.7.7
Content-Length:  0


    -- Channel PJSIP/1101-00000001 left 'native_rtp' basic-bridge <e9d3bf79-2d3f-42f3-ae8e-24781dae1410>
    -- Channel PJSIP/1102-00000000 left 'native_rtp' basic-bridge <e9d3bf79-2d3f-42f3-ae8e-24781dae1410>
  == Spawn extension (default, 1101, 1) exited non-zero on 'PJSIP/1102-00000000'
<--- Transmitting SIP request (407 bytes) to UDP:192.168.100.12:60773 --->
BYE sip:1102@192.168.100.12:60773 SIP/2.0
Via: SIP/2.0/UDP 192.168.100.10:5060;rport;branch=z9hG4bKPjbf2343d9-f3f4-40d8-a365-0af518cd30b7
From: <sip:1101@192.168.100.10>;tag=dab28d84-1b8e-49f0-8a97-9cc960ae3ede
To: <sip:1102@192.168.100.10>;tag=9480006f
Call-ID: vAS_mOFDoAoDYkDQC2-3nw..
CSeq: 23837 BYE
Reason: Q.850;cause=16
Max-Forwards: 70
User-Agent: Asterisk PBX 14.7.7
Content-Length:  0


<--- Received SIP response (396 bytes) from UDP:192.168.100.12:60773 --->
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.100.10:5060;rport=5060;branch=z9hG4bKPjbf2343d9-f3f4-40d8-a365-0af518cd30b7
Contact: <sip:1102@192.168.100.12:60773;transport=UDP>
To: <sip:1102@192.168.100.10>;tag=9480006f
From: <sip:1101@192.168.100.10>;tag=dab28d84-1b8e-49f0-8a97-9cc960ae3ede
Call-ID: vAS_mOFDoAoDYkDQC2-3nw..
CSeq: 23837 BYE
User-Agent: Z 5.2.19 rv2.8.99
Content-Length: 0


<--- Received SIP request (871 bytes) from UDP:192.168.100.12:60773 --->
REGISTER sip:192.168.100.10;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 192.168.100.12:60773;branch=z9hG4bK-524287-1---671059344aea17da
Max-Forwards: 70
Contact: <sip:1102@192.168.100.12:60773;rinstance=bb36e3700b19ab66;transport=UDP>
To: <sip:1102@192.168.100.10;transport=UDP>
From: <sip:1102@192.168.100.10;transport=UDP>;tag=fdd0921c
Call-ID: L-sYh-AYK1vziYMAxR-ZZA..
CSeq: 83 REGISTER
Expires: 30
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
User-Agent: Z 5.2.19 rv2.8.99
Authorization: Digest username="1102",realm="asterisk",nonce="1536747441/9320d72e2a36b5fa787dcfc1ae3c0e5f",uri="sip:192.168.100.10;transport=UDP",response="73c8cb2aa34a7cc759c0a438bcff5d1f",cnonce="e8bfad38a7ee2207dcdfeddf1540cadd",nc=00000002,qop=auth,algorithm=md5,opaque="69a17a9669006cb8"
Allow-Events: presence, kpml, talk
Content-Length: 0


<--- Transmitting SIP response (524 bytes) to UDP:192.168.100.12:60773 --->
SIP/2.0 401 Unauthorized
Via: SIP/2.0/UDP 192.168.100.12:60773;rport=60773;received=192.168.100.12;branch=z9hG4bK-524287-1---671059344aea17da
Call-ID: L-sYh-AYK1vziYMAxR-ZZA..
From: <sip:1102@192.168.100.10>;tag=fdd0921c
To: <sip:1102@192.168.100.10>;tag=z9hG4bK-524287-1---671059344aea17da
CSeq: 83 REGISTER
WWW-Authenticate: Digest  realm="asterisk",nonce="1536747494/ebfa7b6b8c07259595c2337eaf48caf6",opaque="2d9f8e4450a8be95",stale=true,algorithm=md5,qop="auth"
Server: Asterisk PBX 14.7.7
Content-Length:  0


<--- Received SIP request (871 bytes) from UDP:192.168.100.12:60773 --->
REGISTER sip:192.168.100.10;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 192.168.100.12:60773;branch=z9hG4bK-524287-1---9bea5a571dff1e6a
Max-Forwards: 70
Contact: <sip:1102@192.168.100.12:60773;rinstance=bb36e3700b19ab66;transport=UDP>
To: <sip:1102@192.168.100.10;transport=UDP>
From: <sip:1102@192.168.100.10;transport=UDP>;tag=fdd0921c
Call-ID: L-sYh-AYK1vziYMAxR-ZZA..
CSeq: 84 REGISTER
Expires: 30
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
User-Agent: Z 5.2.19 rv2.8.99
Authorization: Digest username="1102",realm="asterisk",nonce="1536747494/ebfa7b6b8c07259595c2337eaf48caf6",uri="sip:192.168.100.10;transport=UDP",response="0a3a1d2780d0dce9a7ebb6fd7263d6f7",cnonce="b2185fb67da2031cbc96d2842b527d13",nc=00000001,qop=auth,algorithm=md5,opaque="2d9f8e4450a8be95"
Allow-Events: presence, kpml, talk
Content-Length: 0


<--- Transmitting SIP response (486 bytes) to UDP:192.168.100.12:60773 --->
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.100.12:60773;rport=60773;received=192.168.100.12;branch=z9hG4bK-524287-1---9bea5a571dff1e6a
Call-ID: L-sYh-AYK1vziYMAxR-ZZA..
From: <sip:1102@192.168.100.10>;tag=fdd0921c
To: <sip:1102@192.168.100.10>;tag=z9hG4bK-524287-1---9bea5a571dff1e6a
CSeq: 84 REGISTER
Date: Wed, 12 Sep 2018 10:18:14 GMT
Contact: <sip:1102@192.168.100.12:60773;rinstance=bb36e3700b19ab66>;expires=59
Expires: 60
Server: Asterisk PBX 14.7.7
Content-Length:  0


<--- Received SIP request (871 bytes) from UDP:192.168.100.11:64565 --->
REGISTER sip:192.168.100.10;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 192.168.100.11:64565;branch=z9hG4bK-524287-1---d38fb6b1601d320d
Max-Forwards: 70
Contact: <sip:1101@192.168.100.11:64565;rinstance=c41238c9fa63c32e;transport=UDP>
To: <sip:1101@192.168.100.10;transport=UDP>
From: <sip:1101@192.168.100.10;transport=UDP>;tag=2b77e418
Call-ID: n_37x_qYXxuC7ujmJvV-zw..
CSeq: 77 REGISTER
Expires: 30
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
User-Agent: Z 5.2.19 rv2.8.99
Authorization: Digest username="1101",realm="asterisk",nonce="1536747468/58f75ebd79c5a3f6af370312febb7ba5",uri="sip:192.168.100.10;transport=UDP",response="f044928c47e12356d62285a8831205b6",cnonce="f2ec1d7554ff185563af988022d02443",nc=00000002,qop=auth,algorithm=md5,opaque="3babbb6a2f58c82c"
Allow-Events: presence, kpml, talk
Content-Length: 0


<--- Transmitting SIP response (524 bytes) to UDP:192.168.100.11:64565 --->
SIP/2.0 401 Unauthorized
Via: SIP/2.0/UDP 192.168.100.11:64565;rport=64565;received=192.168.100.11;branch=z9hG4bK-524287-1---d38fb6b1601d320d
Call-ID: n_37x_qYXxuC7ujmJvV-zw..
From: <sip:1101@192.168.100.10>;tag=2b77e418
To: <sip:1101@192.168.100.10>;tag=z9hG4bK-524287-1---d38fb6b1601d320d
CSeq: 77 REGISTER
WWW-Authenticate: Digest  realm="asterisk",nonce="1536747521/1968664e876ff127403f348f2e5d75ab",opaque="638886516705052e",stale=true,algorithm=md5,qop="auth"
Server: Asterisk PBX 14.7.7
Content-Length:  0


<--- Received SIP request (871 bytes) from UDP:192.168.100.11:64565 --->
REGISTER sip:192.168.100.10;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 192.168.100.11:64565;branch=z9hG4bK-524287-1---2c1ffb874f9d4f94
Max-Forwards: 70
Contact: <sip:1101@192.168.100.11:64565;rinstance=c41238c9fa63c32e;transport=UDP>
To: <sip:1101@192.168.100.10;transport=UDP>
From: <sip:1101@192.168.100.10;transport=UDP>;tag=2b77e418
Call-ID: n_37x_qYXxuC7ujmJvV-zw..
CSeq: 78 REGISTER
Expires: 30
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
User-Agent: Z 5.2.19 rv2.8.99
Authorization: Digest username="1101",realm="asterisk",nonce="1536747521/1968664e876ff127403f348f2e5d75ab",uri="sip:192.168.100.10;transport=UDP",response="5ee5d9a23686a6d2bb714db1651717a0",cnonce="1bf3685ec9072567ac419bac54556fd9",nc=00000001,qop=auth,algorithm=md5,opaque="638886516705052e"
Allow-Events: presence, kpml, talk
Content-Length: 0


<--- Transmitting SIP response (486 bytes) to UDP:192.168.100.11:64565 --->
SIP/2.0 200 OK
Via: SIP/2.0/UDP 192.168.100.11:64565;rport=64565;received=192.168.100.11;branch=z9hG4bK-524287-1---2c1ffb874f9d4f94
Call-ID: n_37x_qYXxuC7ujmJvV-zw..
From: <sip:1101@192.168.100.10>;tag=2b77e418
To: <sip:1101@192.168.100.10>;tag=z9hG4bK-524287-1---2c1ffb874f9d4f94
CSeq: 78 REGISTER
Date: Wed, 12 Sep 2018 10:18:41 GMT
Contact: <sip:1101@192.168.100.11:64565;rinstance=c41238c9fa63c32e>;expires=59
Expires: 60
Server: Asterisk PBX 14.7.7
Content-Length:  0


```
