#!/bin/bash

LOCATION="${LOCATION:-Malbork}"
curl -s "wttr.in/${LOCATION}?format=%C"
echo
