#!/bin/bash

ip addr show wlan0 | awk '/state/ {print $9}'
