# ROS
These are few scripts to create and manage ROS workspace and packages

First thing install ROS ( http://wiki.ros.org/ROS/Installation )

1. After checkout this project (ex ~/projects/ROS) you need to
   add following to your .bashrc

        ROS_SCRIPTS=~/projects/ROS

        # Source desired ROS release
        source /opt/ros/${ROS_DISTRO}/setup.bash

        pathadd() {
            if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
                PATH="$1:${PATH:+"$PATH"}"
            fi
        }

        # This is to make sure no doubles in $PATH
        pathadd ${ROS_SCRIPTS}

2. Refresh your env by running
        source ~/.bashrc

3. Check if ROS_SCRIPTS in your PATH
        echo ${PATH}

4. If all good you should be able to create workspace and packages

5. At any point your can run ros_env.sh (should be in your path at this point)
   This prints various environment variables useful to know what is going on

6. To create workspace/s execute following command.
   You can repeat this command for every new workspace

        ros_make_ws.sh name_of_your_new_workpsace

7. At this point you can change path to any old or new workspace and from
   workspace root path execute following command to change environment
   to current workspace. In this example ~/projects/ is path where all
   workspaces are placed

        cd ~/projects/name_of_your_new_workpsace
        ./etc/ros_switch_ws.sh
        
   Please check printed enviroment variables

8. At this point if there were no errors you should be good and set to work with
   selected {$ROS_WORKSPACE}
   
9. If you want to clean your workspace execute following command 
   in current {$ROS_WORKSPACE}
        ./etc/ros_clean_ws.sh
        
10. To build entire workspace execute following command in current {$ROS_WORKSPACE}
        catkin_make
        
11. To create your own package in current ${ROS_WORKSPACE} run following command
        ./etc/ros_create_pkg.sh -p pka_name

    If you wnat ot create rqt plugin then add -g. This switch will also create
    resource folder which should be used to Qt UI files
        ./etc/ros_create_pkg.sh -p pka_name -g
   
12. When you start ROS logs and .pid files will be located in your
    ${ROS_WORKSPACE}/run/ folder 

13. You can start roscore and its log should be in {$ROS_WORKSPACE}/run
    roscore &> /dev/null &

14. You can use ros_rqt.sh to start roscore (it checks if one is not running)
    and rqt app. ROS logs will be placed in {$ROS_WORKSPACE} activated by
    ./etc/ros_switch_ws.sh

15. There is also ros_kill.sh which will killed roscore. It will print message
    if one was running. Else it will print nothing


More to come
