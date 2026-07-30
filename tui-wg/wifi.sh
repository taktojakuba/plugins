#!/bin/bash

IFACE="${WIFI_IFACE:-wlan0}"
ip addr show "$IFACE" | awk '/state/ {print $9}'
