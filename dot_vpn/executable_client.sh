#!/bin/sh
# Initialize client-to-site Wireguard VPN connection

# Wireguard interface
interface=wg0

# systemd service unit of the defined interface
unit="wg-quick@${interface}.service"

# start/stop service
if [ ! -z $1 ]
then
	sudo systemctl $1 $unit
fi

# print status
systemctl status --no-pager --full $unit
