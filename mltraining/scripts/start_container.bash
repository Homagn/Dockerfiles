#=========== the following 2 lines use if you need to view some opencv window and are connecting using remote desktop=========

xhost +

sudo nvidia-docker run --rm -ti --mount type=bind,source=/home/homag/Desktop/ml,target=/ml --mount type=bind,source=/home/homag/Desktop/datasets,target=/datasets --privileged --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --env="QT_X11_NO_MITSHM=1" mltraining:latest

#=========== old one =========
#sudo nvidia-docker run --rm -ti --mount type=bind,source=/home/homag/Desktop/ml,target=/ml --mount type=bind,source=/home/homag/Desktop/datasets,target=/datasets --privileged --net=host --ipc=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --env="QT_X11_NO_MITSHM=1" homagni/mltraining:latest

#=========== optionally use this if youre utilizing tf gpu from putty in remote computer =========
#sudo nvidia-docker run --rm -ti --mount type=bind,source=/datadrive/ml/projects,target=/projects --privileged --net=host --ipc=host tf-gpu:latest
