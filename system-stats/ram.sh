#!/bin/bash
top -bn1 | awk '/MiB Mem/ {printf "%.0f%%\n", ($8/$4)*100}'
