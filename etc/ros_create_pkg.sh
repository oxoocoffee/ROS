#!/bin/bash
# By Robert J. Gebis (oxoocoffee)
# rjgebis AT g mail DOT com

if [ $# == "0" ]
then
  echo "Usage: `basename $0` [-p ros_pkg] [-q]"
  echo "  -p ros-pkg - new pkg name (required)"
  echo "  -g         - enable rqt gui cpp (optional)"
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

ROS_RQT_GUI=
ROS_PKG_NAME=

OPTIND=1 # Reset is necessary if getopts was used previously in the script.  It is a good idea to make this local in a function.

while getopts "p:g" opt; do
    case "$opt" in
        p)
            ROS_PKG_NAME=${OPTARG}
            shift
            ;;
        g)
            ROS_RQT_GUI="rqt_gui rqt_gui_cpp"
	    ;;
        --)
	    # No more options left.
            shift
            break
	    ;;

        --default)
	    shift
	    ;;
     esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.

if [ -z "${ROS_PKG_NAME}" ]; then
    echo " ERROR: Package name missing: -p pkg_name"
    exit 1
fi

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname ${SCRIPT}`

# Replace all - with _
ROS_PKG_NAME=${ROS_PKG_NAME//[-]/_}

#response=""
echo ""
echo "You are about to create ROS package ${ROS_PKG_NAME}"
echo "in workspace ${ROS_WORKSPACE}"
echo ""
read -r -p "Are you sure? [y/N] " response
 
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    if [ -d "${ROS_WORKSPACE}/src/${ROS_PKG_NAME}" ]; then
      echo "Package ${ROS_PKG_NAME} already exists..."
      echo ""
      exit -1
    fi

    CWD=$(pwd)

    echo "Creating ROS package: ${ROS_WORKSPACE}/src/${ROS_PKG_NAME}"
    echo ""

    cd $ROS_WORKSPACE/src 

    catkin_create_pkg ${ROS_PKG_NAME} roscpp std_msgs dynamic_reconfigure message_generation sensor_msgs ${ROS_RQT_GUI}
    mkdir ./${ROS_PKG_NAME}/srv
    mkdir ./${ROS_PKG_NAME}/msg
    mkdir ./${ROS_PKG_NAME}/launch

    if [ -v ${ROS_RQT_GUI} ]; then
        mkdir ./${ROS_PKG_NAME}/resource
    fi

    echo ""
    echo "Success!!!"
fi

echo ""
