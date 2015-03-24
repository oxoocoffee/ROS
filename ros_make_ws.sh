#!/bin/bash
# By Robert J. Gebis (oxoocoffee)
# rjgebis AT g mail DOT com

echo ""

if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` <ros-ws-name>"
  echo ""
  exit -1
fi

if [ -z "$ROS_ROOT" ]; then
    echo "Need to set ROS_ROOT"
    echo "Did you add \"source /opt/ros/RELEASE/setup.bash\" to .bashrc?"
    echo ""
    exit 1
fi

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`

if [ ! -x "$SCRIPTPATH/ros_env.sh" ] ; then
  echo "Missing ros_env.sh in $SCRIPTPATH"
  echo ""
  exit -1
fi

if [ ! -x "$SCRIPTPATH/etc/ros_clean_ws.sh" ] ; then
  echo "Missing ros_clean_ws.sh in $SCRIPTPATH"
  echo ""
  exit -1
fi

if [ ! -x "$SCRIPTPATH/etc/ros_clean_env.sh" ] ; then
  echo "Missing ros_clean_env.sh in $SCRIPTPATH"
  echo ""
  exit -1
fi

if [ ! -x "$SCRIPTPATH/etc/ros_create_pkg.sh" ] ; then
  echo "Missing ros_create_pkg.sh in $SCRIPTPATH"
  echo ""
  exit -1
fi

if [ ! -x "$SCRIPTPATH/etc/ros_switch_ws.sh" ] ; then
  echo "Missing ros_switch_ws.sh in $SCRIPTPATH"
  echo ""
  exit -1
fi

$SCRIPTPATH/etc/ros_clean_env.sh
source ~/.bashrc

path_to_executable=$(which tree)

if [ ! -x "$path_to_executable" ] ; then
  echo "Missing tree utility... Please install it first"
  echo ""
  exit -1
fi

path_to_executable=$(which catkin_init_workspace)

if [ ! -x "$path_to_executable" ] ; then
  echo "Missing catkin_init_workspace utility... Please install it first"
  echo ""
  exit -1
fi

ROS_WS_NAME=$1

# Replace all - with _
ROS_WS_NAME=${ROS_WS_NAME//[-]/_}

if [ -d "${ROS_WS_NAME}" ]; then
  echo "Workspace ${ROS_WS_NAME} already exists..."
  echo ""
  exit -1 
fi

CWD=$(pwd)

echo "Creating ROS workspace: ${ROS_WS_NAME}"

ROS_HOME=${CWD}/${ROS_WS_NAME}/ 

mkdir -p ${ROS_WS_NAME}/src/ > /dev/null 2>&1
mkdir -p ${ROS_WS_NAME}/devel/ > /dev/null 2>&1
mkdir -p ${ROS_WS_NAME}/build/ > /dev/null 2>&1
mkdir -p ${ROS_WS_NAME}/install/ > /dev/null 2>&1
mkdir -p ${ROS_WS_NAME}/etc/ > /dev/null 2>&1
mkdir -p ${ROS_WS_NAME}/bags/ > /dev/null 2>&1
mkdir -p ${ROS_WS_NAME}/run/logs/ > /dev/null 2>&1

chmod -R 750 ${ROS_WS_NAME} > /dev/null 2>&1

cd ${ROS_WS_NAME}/src
catkin_init_workspace > /dev/null 2>&1
cd ..
catkin_make
tree

for file in ./devel/setup.*
do
  echo "export ROS_HOME=${CWD}/${ROS_WS_NAME}/run/" >> "$file"
  echo "export ROS_LOG_DIR=${CWD}/${ROS_WS_NAME}/run/logs/" >> "$file" 
  echo "export ROS_WORKSPACE=${CWD}/${ROS_WS_NAME}/" >> "$file" 
  echo "export CMAKE_INSTALL_PREFIX=${CWD}/${ROS_WS_NAME}/install/" >> "$file"
done

cp -f $SCRIPTPATH/ros_env.sh ./etc/ > /dev/null 2>&1
cp -f $SCRIPTPATH/etc/ros_clean_ws.sh ./etc/ > /dev/null 2>&1
cp -f $SCRIPTPATH/etc/ros_clean_env.sh ./etc/ > /dev/null 2>&1
cp -f $SCRIPTPATH/etc/ros_create_pkg.sh ./etc/ > /dev/null 2>&1
cp -f $SCRIPTPATH/etc/ros_switch_ws.sh ./etc/ > /dev/null 2>&1

echo "# Each time you need to switch workspace" > README.txt
echo "# execute following command from workspace root path" > README.txt
echo "source ./etc/ros_switch_ws.sh" >> README.txt 
echo "" >> README.txt 

echo "# To create new package switch workspace first with above command" > README.txt
echo "# execute following command from workspace root path" > README.txt
echo "./etc/ros_create_pkg.sh pkg-name" >> README.txt 
echo "" >> README.txt 

echo "# To build entire project execute catkin_make in ${ROS_WS_NAME}/" >> README.txt
echo "catkin_make" >> README.txt
echo "" >> README.txt 

echo "# To add new package execute catkin_create_pkg in ${ROS_WS_NAME}/src/" >> README.txt
echo "catkin_create_pkg package_name" >> README.txt
echo "" >> README.txt 

echo "# To print ROS environment" >> README.txt
echo "./etc/ros_env.sh" >> README.txt
echo "" >> README.txt 

echo "# To clean workspace and remote logs" >> README.txt
echo "./etc/ros_clean_ws.sh" >> README.txt
echo "" >> README.txt 

chmod 640 README.txt

echo "Workspace: $ROS_HOME"
echo "!!! Workspace $ROS_WS_NAME created !!!"
echo ""
echo ""
echo ""
echo "Please read $ROS_WS_NAME/README.txt"
echo ""
echo "--------------------------------------------------------"
echo "- Next step is to enable switch enviroment to $ROS_WS_NAME -"
echo "- Run following commend to switch to current workspace -"
echo "-                                                      -"
echo " cd $ROS_HOME    
echo " source ./etc/ros_switch_ws.sh 
echo "--------------------------------------------------------"
echo ""

