#!/bin/bash

BASE_PATH="/etc/home-server"
FILE_NAME=$0
FILE_NAME="${FILE_NAME:2}"

printRedText() {
  printf '\e[31m%s\e[0m' "$1"
}

printYellowText() {
  printf '\e[33m%s\e[0m' "$1"
}

printGreenText() {
  printf '\e[32m%s\e[0m' "$1"
}

printError() {
  printf "\n"
  printRedText "  ERROR: $1"
  printf "\n\n"
}

requireRootPrivileges() {
  if [[ $(id -u) -ne 0 ]]; then
    printError "Script must be run with root privileges"
    exit 1
  fi
}

requireDirectoryExists() {
  if ! [[ -d "$1" ]]; then
    printError "Directory \"$1\" does not exist"
    exit 1
  fi
}

requireFileExists() {
  if ! [[ -f "$1" ]]; then
    printError "File \"$1\" does not exist"
    exit 1
  fi
}

printHelp() {
  printf "%s\n" "  NAME"
  printf "%s\n\n" "         $FILE_NAME - Perform operations on services under \"$BASE_PATH\""
  printf "%s\n" "  OPTIONS"
  printf "%s\n" "         --startup"
  printf "%s\n\n" "            Start all services"
  printf "%s\n" "         --update"
  printf "%s\n" "            Update all services, by shutting them down, pulling the latest images"
  printf "%s\n\n" "            that are defined in the compose files and restarting them."
  printf "%s\n" "         --shutdown"
  printf "%s\n\n" "            Shutdown all services, removing containers, networks, volumes."
  printf "%s\n" "            By default, the operations are performed on all services. If you want to perform the"
  printf "%s\n" "            operation only on certain services, then provide a whitespace separated list of services."
  printf "%s\n\n" "            (e.g. --<option> service-1 service-2 ... )"
}

printServiceName() {
  serviceDir=$(dirname "$1")
  serviceDir=${serviceDir##*/}
  printf "%s\n" "$serviceDir"
}

runCountdown() {
  i=$1
  while [[ i -ne 0 ]]; do
    printf "\b%s" "$i"
    sleep 1
    ((i = i - 1))
  done
  printf "\r%s\r" "                          "
}

startupBanner="
+=======================================================================+
|   _                                                                   |
|  | |__   ___  _ __ ___   ___           ___  ___ _ ____   _____ _ __   |
|  | '_ \\ / _ \\| '_ \` _ \\ / _ \\  _____  / __|/ _ \\ '__\\ \\ / / _ \ '__|  |
|  | | | | (_) | | | | | |  __/ |_____| \\__ \\  __/ |   \\ V /  __/ |     |
|  |_| |_|\\___/|_| |_| |_|\\___|         |___/\\___|_|    \\_/ \\___|_|     |
|                                                                       |
|      by: Daniel Pallinger                                             |
+=======================================================================+"

printf "%s\n\n" "$startupBanner"

requireRootPrivileges

numberOfArguments=$#
if [ $numberOfArguments -eq 0 ]; then
  printError "You need to specify an operation"
  printHelp
  exit 1
fi

[ "$1" == "--startup" ] && startup=true && shift
[ "$1" == "--update" ] && update=true && shift
[ "$1" == "--shutdown" ] && shutdown=true && shift
[ "$1" == "--help" ] && printHelp && exit 1

requireDirectoryExists "$BASE_PATH"
cd "$BASE_PATH" || exit 1

printf "%s\n" "  The following services were selected from \"$BASE_PATH\""

composeFiles=()

if [ $# -gt 0 ]; then
  while [ $# -gt 0 ]; do
    file="$BASE_PATH/$1/docker-compose.yml"
    requireDirectoryExists "$(dirname "$file")"
    requireFileExists "$file"
    printf "    - "
    printServiceName "$file"
    composeFiles+=("$file")
    shift
  done
else
  for file in ./*/docker-compose.yml; do
    printf "    - "
    printServiceName "$file"
    filepath=$(realpath "$file")
    composeFiles+=("$filepath")
  done
fi

printf "\n"
[ "$startup" == true ] && printGreenText "  Startup " && printf "will begin in  "
[ "$update" == true ] && printYellowText "  Update " && printf "will begin in  "
[ "$shutdown" == true ] && printRedText "  Shutdown " && printf "will begin in  "

runCountdown 5

# Startup
if [ "$startup" == true ]; then
  for composeFile in "${composeFiles[@]}"; do
    printf "\n"
    printGreenText "Start "
    printServiceName "$composeFile"
    sudo docker compose -f "$composeFile" up --detach
  done
fi

# Update
if [ "$update" == true ]; then
  for composeFile in "${composeFiles[@]}"; do
    printf "\n"
    printRedText "Shutdown "
    printServiceName "$composeFile"
    sudo docker compose -f "$composeFile" down >/dev/null
  done

  for composeFile in "${composeFiles[@]}"; do
    printf "\n"
    printYellowText "Pull new images for "
    printServiceName "$composeFile"
    sudo docker compose -f "$composeFile" pull >/dev/null
  done

  for composeFile in "${composeFiles[@]}"; do
    printf "\n"
    printGreenText "Start "
    printServiceName "$composeFile"
    sudo docker compose -f "$composeFile" up --detach >/dev/null
  done
fi

# Shutdown
if [ "$shutdown" == true ]; then
  for composeFile in "${composeFiles[@]}"; do
    printf "\n"
    printRedText "Shutdown "
    printServiceName "$composeFile"
    sudo docker compose -f "$composeFile" down
  done
fi

printf "\n"
printGreenText "Done"
printf "\n\n"
