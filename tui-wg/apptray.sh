#!/bin/bash

# apps to search for, each entry: "Friendly Name|command|process"
DEFAULT_APPS=(
  "Steam|steam|steam"
  "Vesktop|vesktop|vesktop"
  "OBS Studio|obs|obs"
  "Discord|discord|discord"
  "Spotify|spotify|spotify"
)

# usage:
#   apptray.sh                        -> list running apps (built-in list)
#   apptray.sh list [entry...]        -> list running apps (given list)
#   apptray.sh activate <name> [...]  -> focus/launch an app
name=""
case "$1" in
  list)
    shift
    ;;
  activate)
    name="$2"
    shift
    ;;
  *)
    name="$1"
    set --
    ;;
esac

if [[ $# -gt 0 ]]; then
  APPS=("$@")
else
  APPS=("${DEFAULT_APPS[@]}")
fi

# find if an app is running
is_running() {
  pgrep -x "$1" >/dev/null 2>&1
}

# fetch running apps
MENU=()   # friendly names
CMD=()    # command to call the app
for entry in "${APPS[@]}"; do
  name_i="${entry%%|*}"
  rest="${entry#*|}"
  cmd_i="${rest%%|*}"
  proc="${entry##*|}"

  if is_running "$proc"; then
    MENU+=("$name_i")
    CMD+=("$cmd_i")
  fi
done

count="${#MENU[@]}"

# list mode: print the running app names
if [[ -z "$name" ]]; then
  for (( i = 0; i < count; i++ )); do
    echo "${MENU[$i]}"
  done
  exit 0
fi

# activate mode: find the app by its friendly name
i=0
for entry_name in "${MENU[@]}"; do
  if [[ "${entry_name,,}" == "${name,,}" ]]; then
    break
  fi
  i=$((i + 1))
done

if (( i >= count )); then
  echo "That app is not running."
  exit 1
fi

# call the app - wake it up from the background
nohup "${CMD[$i]}" >/dev/null 2>&1 &
