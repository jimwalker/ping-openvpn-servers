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
bestfile="unknown"

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
arrayindices=${!hosts[*]}

#for h in "${hosts[@]}"
for index in $arrayindices;
do
   f=${vpnfiles[$index]}
   h=${hosts[$index]}
   #echo "$f $h $index"
   
   p1=$(timeout 1 ping -c 1 $h | grep -o time=[0-9].* | cut -c 6-12)
   p2=$(timeout 1 ping -c 1 $h | grep -o time=[0-9].* | cut -c 6-12)
   p3=$(timeout 1 ping -c 1 $h | grep -o time=[0-9].* | cut -c 6-12)
   #p4=$(ping -c 1 $h | grep -o time=[0-9].* | cut -c 6-12)
   #p5=$(ping -c 1 $h | grep -o time=[0-9].* | cut -c 6-12)

   #if [[ $p1 && $p2 && $p3 && $p4 && $p5 ]] 
   if [[ $p1 && $p2 && $p3 ]] 
   then
	  # Sum up floats
	  #sum=$(echo "scale=2;$p1 + $p2 + $p3 + $p4 + $p5" | bc)
	  sum=$(echo "scale=2;$p1 + $p2 + $p3" | bc)
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
	     besthost=$h
		 bestfile=$f
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
   echo "$bestfile,$besthost,$bestping"
fi
