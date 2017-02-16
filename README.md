## ping-openvpn-servers
Find the lowest openvpn server ping with this linux shell script

A single linux shell script that will ping all of the openvpn config files in a directory and display the results for each server. Or pass it the -best flag to get only the server with the lowest ping.  This for the raspberry pi to find the best openvpn server to connect to on start up before using Kodi media center.  The output is comma delimited so you can parse out the file for opening connection to the vpn server if you want.

### Setup
Edit the script and change the following line to set the directory where your openvpn .ovpn files are located.

vpndir=/etc/openvpn

Edit the script and change the following line if you wish to limit the script to certain regions.  For example, my vpn prefixes their server names with "us" for United States.  Example format would be the "us-texas.myvpncompany.com" format. You may need to set it to an empty string for the script to work for you if your format is different.

vpnscope="us"

### Permissions
Be sure to set permissions with: chmod+x pingopenvpnservers.sh

### To run the script

./pingopenvpnservers.sh

./pingopenvpnservers.sh -best

### Output
/etc/openvpn/US California.ovpn,us-california.privateinternetaccess.com,8.45
