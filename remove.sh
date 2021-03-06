#!/bin/bash

# Ask user for confirmation
if (whiptail --title "Remove OpenVPN" --yesno --defaultno "Are you sure you want to remove \
OpenVPN and revert your system to its previous state?" 8 78) then
 whiptail --title "Remove OpenVPN" --infobox "OpenVPN will be removed" 8 78
else
 whiptail --title "Remove OpenVPN" --msgbox "Removal cancelled" 8 78
 exit
fi

# Save the user who called sudo:
REALUSER=$(who am i | awk '{print $1}')

# Remove openvpn
yum -y remove openvpn

# Remove openvpn-related directories
rm -r /etc/openvpn /home/$REALUSER/ovpns

# Remove firewall script and reference to it in interfaces
sed -i '/firewall-openvpn-rules.sh/d' /etc/rc.local
rm /etc/firewall-openvpn-rules.sh

# Disable IPv4 forwarding
sed -i '/net.ipv4.ip_forward=1/d' /etc/sysctl.conf
systemctl restart network.service

whiptail --title "Remove OpenVPN" --msgbox "OpenVPN has been removed and your \
previous settings have been restored. Reboot to apply changes." 8 78
