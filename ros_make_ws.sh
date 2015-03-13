#!/bin/bash
# By Robert J. Gebis (oxoocoffee)
# rjgebis AT g mail DOT com

if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` <ros-ws-name>"
  exit -1
fi

WS_NAME=$1

if [ ! -d "$WS_NAME" ]; then
  echo "Workspace already exists..."
  exit -1 
fi

echo "Creating ROS workspace: $WS_NAME"

mkdir -p $WS_NAME/src/
mkdir -p $WS_NAME/build/
mkdir -p $WS_NAME/devel/
mkdir -p $WS_NAME/install/
