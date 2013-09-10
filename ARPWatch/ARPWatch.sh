#!/usr/bin/env bash

# This script track Default Gateway and duplicate MAC entries in the ARP table 
# in order to detect ARP poisoning and ARP spoofing attacks.
# Notice that it works in a passive way, without scanning the whole subnet.
# If the poisoning attack is already up it will NOT works.

# get Default Gateway IPv4
DG_ip=$(netstat -rn -f inet | grep -e 'default' | awk '{print $2}')
# get Default Gateway MAC address
DG_MAC=$(arp -na | grep -w "$DG_ip" | awk '{print $4}')

if [ ! -f /tmp/ARPWatch ]
then
	echo "$DG_MAC" > /tmp/ARPWatch
fi

logger -i -p user.notice -t ARPWatch "Default Gateway MAC Address is $(cat /tmp/ARPWatch)"

# check the ARP table for duplicates
DUP=$(arp -an | awk '{print $4}' | sort | uniq -c | grep -v ' 1 ' | wc -l)

if [ "$DG_MAC" != $(cat /tmp/ARPWatch) -o $DUP -ge 1 ] 
then
	logger -i -p user.warn -t ARPWatch "### WARNING ### Potential ARP Poisoning"
	logger -i -p user.warn -t ARPWatch "$DUP"
fi
