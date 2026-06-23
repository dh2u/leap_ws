#!/bin/bash

ROS_WS_NAME="leap_ws"
ROS_WS="${ROS_WS:-$HOME/$ROS_WS_NAME}"
FASTDDS_FILENAME="fastdds.xml"

# ROS setup
source /opt/ros/jazzy/setup.bash
source "$ROS_WS/install/setup.bash"

# DDS config
export ROS_DOMAIN_ID=31
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
export FASTDDS_DEFAULT_PROFILES_FILE="file://${ROS_WS}/${FASTDDS_FILENAME}"

# Go to workspace
mkdir -p "$ROS_WS"
cd "$ROS_WS"