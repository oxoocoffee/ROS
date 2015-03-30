#!/bin/sh

if [ -z "$ROS_ROOT" ]; then
    echo "Need to set ROS_ROOT"
    echo "Did you add \"source /opt/ros/RELEASE/setup.bash\" to .profile?"
    echo ""
    exit 1
fi

if [ -z "$ROS_WORKSPACE" ]; then
    echo "Need to set ROS_WORKSPACE"
    echo "Did you \"source .\etc\ros_switch_ws.sh\"?"
    echo ""
    exit 1
fi

echo ""
echo "---------------------------------------------"
echo ""

SERVICE='roscore'
 
if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    echo "$SERVICE service: Is Running"
else
    echo "$SERVICE service: Is Starting"
    roscore &> /dev/null &
fi

rqt &

echo ""
echo "ROS_ROOT:        ${ROS_ROOT}"
echo "ROS_WORKSPACE:   ${ROS_WORKSPACE}"
echo ""
echo "---------------------------------------------"
echo ""
