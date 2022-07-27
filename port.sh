#!/bin/bash

text="ERROR"
echo -e "Provide Port Number:"
read port < /dev/tty

re='^[0-9]+$'
if !  [[ $port =~ $re ]] ; then
   echo "ERROR: Not a Valid Port Number" >&2; exit 1
fi

num=65535

if   [[ $port -gt $num ]] ; then
   echo "ERROR: Not a Valid Port Number" >&2; exit 1
fi

if   [[ $port == 21 ]] ; then
   echo "ERROR: This port is not allowed due to the security." >&2; exit 1
fi

dup=$(cat /etc/shorewall/rules | grep $port )

#echo $dup


if [[ -z $dup ]];

then
      echo	"Good to Go!"

else

	echo "ERROR: Port is already in use."
	exit
fi


sed -i "/tcp.*4200/i ACCEPT\t\tnet\tfw\ttcp\t$port\t\t\t#Custom port by PO" "/etc/shorewall/rules"

echo "Opening Port..."

shorewall update > /dev/null 2>&1
out=$(shorewall restart 2>&1 | grep 'ERROR')

if [[ "$out" == *"$text"* ]]; then
  echo "There is something wrong! Please contact any senior."
	exit
fi
echo -e "Port has been enabled."
