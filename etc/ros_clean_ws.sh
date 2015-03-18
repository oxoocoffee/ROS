#!/bin/bash
# By Robert J. Gebis (oxoocoffee)
# rjgebis AT g mail DOT com

echo ""
response=""

if [ $# -ne 1 ] 
   then
       read -r -p "Are you sure? [y/N] " response
   else
       response=$1
fi

if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
   then
       catkin_make clean
       rm -rf ./run/*.pid ./run/logs/*
fi

