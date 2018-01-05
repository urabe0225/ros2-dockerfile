FROM ubuntu:16.04
MAINTAINER Kazuki Urabe <urabe.kazuki@tis.co.jp>

## aptのsourceの追加
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt update && apt install -y curl
RUN curl http://repo.ros2.org/repos.key | apt-key add -
RUN sh -c 'echo "deb [arch=amd64,arm64] http://repo.ros2.org/ubuntu/main xenial main" > /etc/apt/sources.list.d/ros2-latest.list'

## 環境変数の設定
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO kinetic
ENV ROS2_DISTRO ardent
EXPOSE 10100

## ROS1のインストール
RUN apt update && apt install -y ros-kinetic-desktop-full

## ROS2のインストール
RUN apt install -y `apt list "ros-ardent-*" 2> /dev/null | grep "/" | awk -F/ '{print $1}' | grep -v -e ros-ardent-ros1-bridge -e ros-ardent-turtlebot2- | tr "\n" " "`
RUN apt install -q -y python3-pip
RUN pip3 install -U argcomplete

## ROS1ブリッジのインストール
RUN apt install -y ros-ardent-ros1-bridge \
ros-ardent-turtlebot2-* && rm -rf /var/lib/apt/lists/*

## ROS2の環境設定
CMD source /opt/ros/ardent/setup.bash
CMD source /opt/ros/ardent/share/ros2cli/environment/ros2-argcomplete.bash
