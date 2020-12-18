#==========================================================================
#(Ubuntu and nvidia cuda)
#FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
#(must have cudagl for gazebo)
#https://github.com/NVIDIA-AI-IOT/redtail/issues/46
FROM nvidia/cudagl:10.1-devel-ubuntu16.04


#==========================================================================
#(python, pip and git)
#(https://stackoverflow.com/questions/25845538/how-to-use-sudo-inside-a-docker-container)

#(good reference) https://github.com/rlworkgroup/gym-sawyer

RUN apt-get update && apt-get install -y sudo software-properties-common


RUN sudo apt-get update && sudo apt-get install -y python-setuptools python-dev python-pip git wget


#==========================================================================
#(ROS essentials)

RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'
RUN sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN sudo apt-get update && sudo apt-get install -y --allow-unauthenticated ros-kinetic-desktop-full

RUN sudo rosdep init
#(dont worry about warning - https://answers.ros.org/question/241112/how-to-run-rosdep-init-and-update-in-dockerfile/)
RUN rosdep update

RUN sudo apt-get install -y --allow-unauthenticated python-rosinstall



#RUN mkdir -p ~/ros_ws/src && source /opt/ros/kinetic/setup.bash
#RUN cd ~/ros_ws && catkin_make
#https://github.com/rlworkgroup/gym-sawyer/blob/master/docker/sawyer-robot/Dockerfile


RUN mkdir -p ~/ros_ws/src
#(whenever source is involved need to run in bask like this)
RUN ["/bin/bash", "-c", \
 "source /opt/ros/kinetic/setup.bash && \
  cd ~/ros_ws && \
  catkin_make"]



RUN sudo apt-get update && sudo apt-get install -y --allow-unauthenticated git-core python-argparse python-wstool python-vcstools python-rosdep ros-kinetic-control-msgs ros-kinetic-joystick-drivers ros-kinetic-xacro ros-kinetic-tf2-ros ros-kinetic-rviz ros-kinetic-cv-bridge ros-kinetic-actionlib ros-kinetic-actionlib-msgs ros-kinetic-dynamic-reconfigure ros-kinetic-trajectory-msgs ros-kinetic-rospy-message-converter

#==========================================================================
#(SAWYER)

#RUN cd ~/ros_ws/src && wstool init . && git clone https://github.com/RethinkRobotics/sawyer_robot.git && wstool merge sawyer_robot/
#sawyer_robot.rosinstall && wstool update

RUN ["/bin/bash", "-c", \
 "cd ~/ros_ws/src && \
  wstool init . && \
  git clone https://github.com/RethinkRobotics/sawyer_robot.git && \
  wstool merge sawyer_robot/sawyer_robot.rosinstall && \
  wstool update"]

RUN ["/bin/bash", "-c", \
	"source /opt/ros/kinetic/setup.bash && \
     cd ~/ros_ws && \
     catkin_make"]

#(to do- not working then do after execution)
#COPY ~/ros_ws/src/intera_sdk/intera.sh ~/ros_ws

#===========================================================================
#(sawyer gazebo)
RUN sudo apt-get update && sudo apt-get install -y --allow-unauthenticated gazebo7 ros-kinetic-qt-build ros-kinetic-gazebo-ros-control ros-kinetic-gazebo-ros-pkgs ros-kinetic-ros-control ros-kinetic-control-toolbox ros-kinetic-realtime-tools ros-kinetic-ros-controllers ros-kinetic-xacro python-wstool ros-kinetic-tf-conversions ros-kinetic-kdl-parser ros-kinetic-sns-ik-lib


RUN cd ~/ros_ws/src && git clone https://github.com/RethinkRobotics/sawyer_simulator.git
RUN ["/bin/bash", "-c", \
 "cd ~/ros_ws/src && \
  wstool merge sawyer_simulator/sawyer_simulator.rosinstall && \
  wstool update"]

RUN ["/bin/bash", "-c", \
 "source /opt/ros/kinetic/setup.bash && \
  cd ~/ros_ws && \
  catkin_make"]


#==========================================================================
#(independent turtlebot)


RUN sudo apt-key del 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN sudo -E apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN sudo apt-get update && apt-get install -y --allow-unauthenticated linux-headers-generic

#(some persisting errors here problems with librealsense )
#(probably because of kernel current its 4.15 needs to be 4.4-> https://github.com/IntelRealSense/librealsense/issues/4781)

#RUN sudo sh -c 'echo "deb-src http://us.archive.ubuntu.com/ubuntu/ xenial main restricted \
#deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-updates main restricted \
#deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse \
#deb-src http://security.ubuntu.com/ubuntu xenial-security main restricted" > \
#/etc/apt/sources.list.d/official-source-repositories.list' && \
#sudo apt-get update

#(https://github.com/IntelRealSense/librealsense/issues/4781)

RUN sudo apt-get install -y binutils cpp cpp-5 dkms fakeroot gcc gcc-5 kmod libasan2 libatomic1 libc-dev-bin libc6-dev libcc1-0 libcilkrts5 libfakeroot libgcc-5-dev libgmp10 libgomp1 libisl15 libitm1 liblsan0 libmpc3 libmpfr4 libmpx0 libquadmath0 libssl-dev libssl-doc libtsan0 libubsan0 libusb-1.0-0 libusb-1.0-0-dev libusb-1.0-doc linux-headers-4.4.0-159 linux-headers-4.4.0-159-generic linux-headers-generic linux-libc-dev make manpages manpages-dev menu patch zlib1g-dev

RUN sudo apt-get install -y libssl-dev libssl-doc libusb-1.0-0 libusb-1.0-0-dev libusb-1.0-doc linux-headers-4.4.0-159 linux-headers-4.4.0-159-generic linux-headers-generic zlib1g-dev

RUN sudo apt-get download ros-kinetic-librealsense
RUN dpkg-deb -R ros-kinetic-librealsense*.deb ros-rslib/


RUN wget https://gist.githubusercontent.com/dizz/404ef259a15e1410d692792da0c27a47/raw/3769e80a051b5f2ce2a08d4ee6f79c766724f495/postinst
RUN chmod +x postinst
RUN cp postinst ros-rslib/DEBIAN

RUN dpkg-deb -b ./ros-rslib/ ros-kinetic-librealsense_1.12.1-0xenial-20190830_icrlab_amd64.deb

# install container friendly libsense
RUN dpkg -i ros-kinetic-librealsense_1.12.1-0xenial-20190830_icrlab_amd64.deb

# lock from updates
RUN apt-mark hold ros-kinetic-librealsense

RUN sudo apt-get install -y --allow-unauthenticated ros-kinetic-librealsense ros-kinetic-turtlebot ros-kinetic-turtlebot-apps ros-kinetic-turtlebot-interactions ros-kinetic-turtlebot-simulator ros-kinetic-ar-track-alvar-msgs 





#===========================================================================
#(execution)
#https://stackoverflow.com/questions/56931649/docker-cannot-connect-to-x-server
#sudo nvidia-docker run --rm -ti --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --env="QT_X11_NO_MITSHM=1" <image_name> <arguments>

#(EXECUTING turtlebot platform)

#spawn a new docker container
#sudo nvidia-docker run --rm -ti --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --env="QT_X11_NO_MITSHM=1" scslab-robots
#(inside that container)
#cd ~/ros_ws
#source /opt/ros/kinetic/setup.bash
#roscore

#(now keep this docker container running and spawn another new docker container)
#(in a new host terminal)
#sudo nvidia-docker run --rm -ti --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --env="QT_X11_NO_MITSHM=1" scslab-robots
#(inside that container)
#cd ~/ros_ws
#source /opt/ros/kinetic/setup.bash
#roslaunch turtlebot_gazebo turtlebot_world.launch
#(takes some time to load but should work !)


#(EXECUTING sawyer platform)
#spawn a new docker container
#sudo nvidia-docker run --rm -ti --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --env="QT_X11_NO_MITSHM=1" scslab-robots
#(inside that container)
#cp ~/ros_ws/src/intera_sdk/intera.sh ~/ros_ws
#apt-get install gedit
#cd ~/ros_ws
#gedit intera.sh
#(an external notepad type screen will pop up you need to change 3 main things)
#your_ip="192.168.XXX.XXX" (change this to the ipvalue you get when you do ifconfig on the host machine)
#change robot_hostname.local to sawyer.local
#change ros_version="indigo" to ros_version="kinetic"
#(finally press ctrl+s to save and close the pop up window)


#(check if simulation of sawyer runs )

#cd ~/ros_ws
#source /opt/ros/kinetic/setup.bash
#./intera.sh sim 
#roslaunch sawyer_gazebo sawyer_world.launch electric_gripper:=true
#(a gazebo simulation should appear containing the robot !)