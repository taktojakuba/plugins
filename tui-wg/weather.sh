#!/bin/bash

LOCATION="${LOCATION:-Warsaw}"
curl -s "wttr.in/${LOCATION}?format=%C"
echo
