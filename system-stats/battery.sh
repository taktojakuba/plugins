#!/bin/bash

upower -b | awk '/percentage:/ {print $2; exit}'
