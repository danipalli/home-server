#!/bin/bash
path="/etc/home-server"

cd "$path"

printf "#################################################\n"
printf "#             Home Server Startup               #\n"
printf "#################################################\n\n"
printf "Starting services:\n"

for file in ./*/docker-compose.yml ; do
        fdir=$(dirname "$file")
        dir="${fdir:2}"
        printf "\t- $dir\n"
        cd "$path/$dir"
        sudo docker-compose up &
        cd ..
done

printf "\ndone\n"
printf "%b-------------------------------------------------\n"
