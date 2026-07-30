#!/bin/bash
top -bn1 | awk '/Cpu\(s\)/ {printf "%.0f%%\n", 100 - $8}'
