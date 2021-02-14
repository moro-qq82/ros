# docker build -t ros2:eloquent .
FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive

ENV ROS_DISTRO eloquent

# ロケールのセットアップ
RUN apt-get update && apt-get install -y locales && \
    dpkg-reconfigure locales && \
    locale-gen ja_JP ja_JP.UTF-8 && \
    update-locale LC_ALL=ja_JP.UTF-8 LANG=ja_JP.UTF-8
ENV LC_ALL   ja_JP.UTF-8
ENV LANG     ja_JP.UTF-8
ENV LANGUAGE ja_JP.UTF-8

# APTソースリストの設定
RUN apt-get update && \
    apt-get install -y curl gnupg2 lsb-release && \
    curl http://repo.ros2.org/repos.key | apt-key add - && \
    sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu \
    `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list' && \
    apt-get update

# ROS2パッケージのインストール
RUN export ROS_DISTRO=eloquent && \
    apt-get install -y ros-$ROS_DISTRO-desktop \
    python3-colcon-common-extensions python3-rosdep python3-argcomplete && \
    rosdep init && \
    rosdep update

# GUI用設定
RUN apt install -y x11-apps && \
    export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer



# gazebo
ENV DEBIAN_FRONTEND=noninteractive

### GTX1650用ドライバーを入れる
RUN apt-get update && \
    apt-get install -yq wget curl git build-essential vim sudo lsb-release locales bash-completion tzdata ros-eloquent-gazebo-ros-pkgs nvidia-driver-460
#    curl -sSL http://get.gazebosim.org | sh



USER developer

## 環境設定
RUN    echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
