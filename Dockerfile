# Use the official ROS 2 Humble Perception image as the base image
FROM ros:humble-perception-jammy

# Set the locale environment variables (optional but recommended)
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt update
RUN apt install -y ros-humble-moveit && apt install -y ros-humble-ament-cmake
RUN curl -sSL http://get.gazebosim.org | sh
RUN cd /home && mkdir -p dev_ws/src && cd dev_ws/src

SHELL ["/bin/bash", "-c"]

RUN source /opt/ros/humble/setup.bash && cd /home/dev_ws/src && git clone https://github.com/xArm-Developer/xarm_ros2.git --recursive -b $ROS_DISTRO \
    && cd xarm_ros2 && git pull && git submodule sync && git submodule update --init --remote \
    && cd /home/dev_ws/src && rosdep update && rosdep install --from-paths . --ignore-src --rosdistro $ROS_DISTRO -y \
    && cd /home/dev_ws && colcon build && source install/setup.bash

# add the source/setup.bash to the bashrc
RUN echo "source /home/dev_ws/install/setup.bash" >> /root/.bashrc
