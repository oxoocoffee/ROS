#/bin/bash

if [[ ${0##*/} == -* ]]; then
    source ./etc/ros_clean_env.sh 
    source ~/.bashrc
    source ./devel/setup.bash
    ./etc/ros_env.sh
else
    echo ""
    echo "!!! You must source this file"
    echo "!!! from ROS workspace root folder"
    echo ""
    echo " source ./etc/ros_switch_ws.sh" 
    echo ""
fi


