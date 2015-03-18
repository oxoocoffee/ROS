#!/bin/bash
# By Robert J. Gebis (oxoocoffee)
# rjgebis AT g mail DOT com

if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` <ros-pkg>"
  echo ""
  exit -1
fi

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

if [ ! -d "$ROS_WORKSPACE/src" ] ; then
  echo "Missing $ROS_WORKSPACE/src"
  echo ""
  exit -1
fi

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname ${SCRIPT}`

ROS_PKG_NAME=$1

# Replace all - with _
ROS_PKG_NAME=${ROS_PKG_NAME//[-]/_}

if [ -d "${ROS_WORKSPACE}/src/${ROS_PKG_NAME}" ]; then
  echo "Package ${ROS_PKG_NAME} already exists..."
  echo ""
  exit -1
fi

CWD=$(pwd)

echo "Creating ROS package: ${ROS_PKG_NAME}"

cd $ROS_WORKSPACE/src 

catkin_create_pkg ${ROS_PKG_NAME} roscpp std_msgs dynamic_reconfigure message_generation sensor_msgs

