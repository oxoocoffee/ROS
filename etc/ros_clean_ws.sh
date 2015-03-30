#!/bin/bash
# By Robert J. Gebis (oxoocoffee)
# rjgebis AT g mail DOT com

if [ -z "$ROS_WORKSPACE" ]; then
    echo "Need to set ROS_WORKSPACE"
    echo "Did you \"source ROS_WS_PROJECT\etc\ros_switch_ws.sh\"?"
    echo ""
    exit 1
fi

echo "Cleaning $ROS_WORKSPACE"
echo ""

catkin_make clean

echo ""
echo ""
response=""

if [ $# -ne 1 ] 
   then
       read -r -p "Do you want to purge log files? [y/N] " response
   else
       response=$1
fi

if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
   then
       rosclean purge
       echo "Logs purged from ${ROS_LOG_DIR}"
       echo ""
fi

