#!/bin/bash
#Pham Dam Quan - 21020528

open=$(netstat -antp | awk '/LISTEN/ {print $4}' | cut -d':' -f2)
portlist=$(cat portlist)
echo "check status of allowed port:"
for port in $portlist
do
	check=$(echo $open | grep -c $port)
	if [ $check == 1 ]
	then
		echo '+ ' port $port is open
	else
		echo '+ ' port $port is closed
	fi
done

echo "check for unallowed open ports:"
for port in $open
do
	if ! [[ "$portlist" =~ " $port " ]]
	then
		echo '+ ' port $port is open
		pid=$(netstat -antp | grep ":$port " | awk '{print $7}' | cut -d'/' -f1)
		kill -9 $pid
		echo '	- ' Terminate process $pid to close port $port
	fi
done

status=$(systemctl is-active nftables)
echo "check firewall status: " $status
systemctl start nftables
rules=$(nft list ruleset | awk '/dport/ * /accept/ {print $3}')
for port in $portlist
do
	if [[ "$rules" =~ "$port" ]]
	then
		echo '+ ' port $port configured correctly
	else
		echo '+ ' port $port is blocked by firewall
	fi
done
for port in $rules
do
	if ! [[ "$portlist" =~ "$port" ]]
	then
		echo '+ ' port $port should be closed
	fi
done
