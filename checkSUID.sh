#!/bin/bash

pwdperm=$(stat -c "%a" /etc/passwd)
if [ $pwdperm == "644" ]
then
	echo "/etc/passwd configured correctedly"
else
	if [[ "$pwdperm" =~ 6.6 ]]
	then
		echo "/etc/passwd can be changed by any users"
	fi
	if [[ "$pwdperm" =~ 66. ]]
	then
		grp=$(groups)
		if [[ "$grp" == *" root "* ]]
		then
			echo "/etc/passwd can be changed by this user and any user belonging to root group"
		else
			echo "/etc/passwd can be changed by user in root group"
		fi
	fi
fi

echo ''

cplink=$(which cp)
cppath=$(readlink -f $cplink)
cpperm=$(stat -c "%a" $cppath)
if [ $cpperm == "755" ]
then
	echo $cppath configured correctly
elif [ $cpperm == "6755" ]
then
	echo $cppath config error! SUID bit is turned on
else
	echo $cppath config error
	echo $(ls -la $cppath)
fi

echo ''

nanolink=$(which nano)
nanopath=$(readlink -f $nanolink)
nanoperm=$(stat -c "%a" $nanopath)
if [ $nanoperm == "755" ]
then
        echo $nanopath configured correctly
elif [ $nanoperm == "6755" ]
then
        echo $nanopath config error! SUID bit is turned on
else
        echo $nanopath config error
        echo $(ls -la $nanopath)
fi

echo ''

vilink=$(which vi)
vipath=$(readlink -f $vilink)
viperm=$(stat -c "%a" $vipath)
if [ $viperm == "755" ]
then
        echo $vipath configured correctly
elif [ $viperm == "6755" ]
then
        echo $vipath config error! SUID bit is turned on
else
        echo $vipath config error
        echo $(ls -la $vipath)
fi
