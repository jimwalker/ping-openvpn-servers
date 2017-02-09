#!/bin/bash

#Your vpn files directory
vpndir=/etc/openvpn
#use vpnscope to limit servers from us only, empty it if you want
vpnscope="us"


#Do not edit past here
vpnfiles=()
hosts=()
bestping="9999"
besthost="unknown"

#Read files from directory and get connection info
hostdata=$(grep -nr "remote $vpnscope" $vpndir)

#Need to parse into variables
while IFS=: read -r filename dud host; do
  server=$(echo $host | cut -d' ' -f 2)
  # Add to our arrays
  vpnfiles+=("$filename")
  hosts+=("$server")	
done <<< "$hostdata"

#Loop over host array to find best ping
for h in "${hosts[@]}"
do
   
   p1=$(ping -c 1 $h | grep -o time=[0-9].* | cut -c 6-12)
   p2=$(ping -c 1 $h | grep -o time=[0-9].* | cut -c 6-12)
   p3=$(ping -c 1 $h | grep -o time=[0-9].* | cut -c 6-12)
   p4=$(ping -c 1 $h | grep -o time=[0-9].* | cut -c 6-12)
   p5=$(ping -c 1 $h | grep -o time=[0-9].* | cut -c 6-12)

   if [[ $p1 && $p2 && $p3 && $p4 && $p5 ]] 
   then
	  # Sum up floats
	  sum=$(echo "scale=2;$p1 + $p2 + $p3 + $p4 + $p5" | bc)
	  avg=$(echo "scale=2;$sum / 5" | bc)
	  
	  if [ "$1" != "-best" ]
	  then 
	     printf '%s' "$h"
	     printf ' %s\n' "$avg"
	  fi
	  # Get best ping, bash does not do floats so use bc
	  if [ $(echo "$avg < $bestping" | bc) -eq 1 ]
	  then
	     bestping=$avg
	     besthost="$h"
	  fi
   else
      if [ "$1" != "-best" ]
	  then
         printf '%s' "$h"
         printf " BAD\n"
	  fi
   fi
   
done

if [ "$1" == "-best" ]
then 
   echo "$besthost $bestping"
fi