#!/bin/bash
set -eo pipefail

# ----------------------------
# Config
# ----------------------------
ROS_WS_NAME="leap_ws"
ROS_WS="${ROS_WS:-$HOME/$ROS_WS_NAME}"

echo "=== ROS2 Workspace Setup ==="
echo "Workspace: $ROS_WS"

# ----------------------------
# Create workspace
# ----------------------------
mkdir -p "$ROS_WS/src"

# ----------------------------
# Import repositories
# ----------------------------
echo "Importing repositories..."
PYTHONWARNINGS="ignore::DeprecationWarning" \
vcs import "$ROS_WS/src" < "$ROS_WS/$ROS_WS_NAME.repos"

# ----------------------------
# Keep only ros2_module (no renaming here)
# ----------------------------
LEAP_PATH="$ROS_WS/src/leap_hand"

if [ -d "$LEAP_PATH" ]; then
    echo "Configuring LEAP hand (ROS2 only)..."
    cd "$LEAP_PATH"

    git sparse-checkout init --cone
    git sparse-checkout set ros2_module
fi

# ----------------------------
# xArm setup
# ----------------------------
if [ -d "$ROS_WS/src/xarm_ros2" ]; then
    echo "Setting up xArm..."
    cd "$ROS_WS/src/xarm_ros2"
    git submodule update --init --recursive
fi

# ----------------------------
# Build
# ----------------------------
cd "$ROS_WS"

source /opt/ros/jazzy/setup.bash

echo "Installing dependencies..."
rosdep update
rosdep install --from-paths src --ignore-src -r -y \
  --skip-keys "sdformat14 gz-sim8" || true

echo "Building workspace..."
rm -rf build install log
colcon build --symlink-install --packages-ignore xarm_gazebo

echo "=== ✅ Done ==="
echo "source $ROS_WS/install/setup.bash"