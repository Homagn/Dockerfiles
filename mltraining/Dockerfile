#source -https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile

# Copyright 2019 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================
#
# THIS IS A GENERATED DOCKERFILE.
#
# This file was assembled from multiple pieces, whose use is documented
# throughout. Please refer to the TensorFlow dockerfiles documentation
# for more information.

ARG UBUNTU_VERSION=20.04

ARG ARCH=
ARG CUDA=11.2
FROM nvidia/cudagl${ARCH:+-$ARCH}:${CUDA}.0-base-ubuntu${UBUNTU_VERSION} as base
# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG ARCH
ARG CUDA
ARG CUDNN=8.1.0.77-1
ARG CUDNN_MAJOR_VERSION=8
ARG LIB_DIR_PREFIX=x86_64
ARG LIBNVINFER=7.2.2-1
ARG LIBNVINFER_MAJOR_VERSION=7

#get rid of the tz time zone hang
ENV TZ=Asia/Dubai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Needed for string substitution
SHELL ["/bin/bash", "-c"]
# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-${CUDA/./-} \
        libcublas-${CUDA/./-} \
        cuda-nvrtc-${CUDA/./-} \
        libcufft-${CUDA/./-} \
        libcurand-${CUDA/./-} \
        libcusolver-${CUDA/./-} \
        libcusparse-${CUDA/./-} \
        curl \
        libcudnn8=${CUDNN}+cuda${CUDA} \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        software-properties-common \
        unzip


# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:/usr/local/cuda-11.1/lib64:$LD_LIBRARY_PATH

# Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
# dynamic linker run-time bindings
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

RUN python3 -m pip --no-cache-dir install --upgrade \
    "pip<20.3" \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which python3) /usr/local/bin/python

# Options:
#   tensorflow
#   tensorflow-gpu
#   tf-nightly
#   tf-nightly-gpu
# Set --build-arg TF_PACKAGE_VERSION=1.11.0rc0 to install a specific version.
# Installs the latest version by default.
ARG TF_PACKAGE=tensorflow-gpu
ARG TF_PACKAGE_VERSION=
RUN python3 -m pip install --no-cache-dir ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}}

#done installing tensorflow now install the object detection library
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget git
RUN git clone --depth 1 https://github.com/tensorflow/models

RUN apt-get install -y autoconf automake libtool curl make g++ unzip
#install protoc for linux (required to unzip some tensorflow models)

#RUN PROTOC_ZIP=protoc-3.15.8-linux-x86_64.zip
#RUN curl -oL https://github.com/google/protobuf/releases/download/v3.15.8/$PROTOC_ZIP
#RUN unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
#RUN unzip -o $PROTOC_ZIP -d /usr/local include/*
#RUN rm -f $PROTOC_ZIP

RUN apt-get install -y protobuf-compiler

RUN ["/bin/bash", "-c", \
 "cd models/research/ && \
  protoc object_detection/protos/*.proto --python_out=. && \
  cp object_detection/packages/tf2/setup.py . && \
  python -m pip install ."]


#============my packages================
RUN python3 -m pip install -U matplotlib


#install opencv and some graphics dependencies in order to be able to show images through docker container
RUN apt-get update && apt-get install -y wget doxygen curl libjsoncpp-dev libepoxy-dev libglm-dev libosmesa6 libosmesa6-dev libglew-dev libopencv-dev

RUN python3 -m pip install opencv-python

#============setting up tensorflow lite for C ================
ADD assets/TFLiteLibrary/libtensorflowlite_c.so /usr/local/lib/libtensorflowlite_c.so
#ADD assets/TFLiteLibrary/libtensorflowlite_c.so /usr/lib/libtensorflowlite_c.so
ADD assets/TFLiteLibrary/lite /usr/local/include/tensorflow/lite

#============additional libraries================

RUN python3 -m pip install -U scikit-learn
RUN pip install open3d
RUN pip install plyfile

RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113

#make sure opencv can display images 
RUN pip uninstall -y opencv-python-headless 
RUN pip uninstall -y opencv-python
RUN pip install opencv-python
RUN pip install imageio

#Download and move tensorflow object detection models
RUN wget http://download.tensorflow.org/models/object_detection/tf2/20200711/ssd_resnet50_v1_fpn_640x640_coco17_tpu-8.tar.gz
RUN tar -xf ssd_resnet50_v1_fpn_640x640_coco17_tpu-8.tar.gz
RUN mv ssd_resnet50_v1_fpn_640x640_coco17_tpu-8/checkpoint /models/research/object_detection/test_data/


