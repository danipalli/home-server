#!/bin/bash
path="/etc/home-server"

cd "$path"

printf "#################################################\n"
printf "#             Home Server Shutdown              #\n"
printf "#################################################\n\n"
printf "Stopping services:\n"

for file in ./*/docker-compose.yml ; do
        fdir=$(dirname "$file")
        dir="${fdir:2}"
        printf "\t- $dir\n"
        cd "$path/$dir"
        sudo docker-compose stop &
        cd ..
done

printf "\ndone\n"
printf "%b-------------------------------------------------\n"
