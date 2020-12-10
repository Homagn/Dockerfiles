#==========================================================================
#(Ubuntu and nvidia cuda)
FROM ubuntu:20.04

LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 10.1.243
ENV CUDA_PKG_VERSION 10-1=$CUDA_VERSION-1

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-1 \
    && ln -s cuda-10.1 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419"
#==========================================================================


#==========================================================================
#(CUDNN- )
# Install cudnn
ENV CUDNN_VERSION 7.6.4.38
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 \
&& \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*
#==========================================================================



#==========================================================================
#(waveglow dependencies)
#get python, pip and git
RUN apt-get update && apt-get install -y python3-setuptools python3-dev python3-pip git wget

#Dependencies for waveglow
#(when installing requirements for waveglow remove the version caps)
RUN pip3 install torch==1.4.0
RUN pip3 install matplotlib
RUN pip3 install tensorflow
RUN pip3 install numpy
RUN pip3 install inflect==0.2.5
RUN pip3 install librosa
RUN pip3 install scipy
RUN pip3 install tensorboardX
RUN pip3 install Unidecode==1.0.22
RUN pip3 install pillow
#==========================================================================


#==========================================================================
#(waveglow + apex dependencies)
#(In order to access cuda during docker build because of apex)
#https://stackoverflow.com/questions/59691207/docker-build-with-nvidia-runtime

RUN apt-get update && apt-get install -y libsndfile1
RUN git clone https://github.com/NVIDIA/apex
RUN cd /apex && pip3 install -v --disable-pip-version-check --no-cache-dir ./

#==========================================================================



#================================================================================================================================================

#(LOCAL HOST MACHINE SETUP + EXTRA HELPFUL COMMANDS)

#(in local host machine- download and setup waveglow directory)
#git clone https://github.com/NVIDIA/waveglow.git
#cd /waveglow && git submodule init && git submodule update

#(in local machine set aside another folder for different kinds of datasets)
#cd 
#cd waveglow_data
#(download and extract ljspeech)
#wget https://data.keithito.com/data/speech/LJSpeech-1.1.tar.bz2 && tar -xf LJSpeech-1.1.tar.bz2


#(In order to access cuda during docker build because of apex)
#https://stackoverflow.com/questions/59691207/docker-build-with-nvidia-runtime










#========================================================================
#execution instructions
#(export the dataset directory that would contain the LJSpeech wav files)

#export WAVEGLOW_DATA_DIR="/home/homagni/waveglow_data/"

#(mount the waveglow_data directory and create a persistent volume with docker to the host /waveglow directory)
#sudo nvidia-docker run -it --mount type=bind,source=$WAVEGLOW_DATA_DIR,target=/waveglow/data,readonly --volume "/home/homagni/waveglow":/waveglow waveglow

#OR
#(for singularity on cluster)
#(download and build on cluster)
#singularity pull docker://homagni/waveglow_apex:2
#(after complete a .sif file would be created in your current directory)

#(run the built image)
#(here -B does the job of both mount and volume so create a seperate single folder called waveglow_singularity containing both code and data)
#singularity run --nv -c -B /data/Homagni/waveglow:/waveglow waveglow_apex_2.sif
#

#(inside docker container)
#cd
#cd /waveglow

#(loading previous checkpoints)
#in /data/Homagni/waveglow/config.json change the "checkpoint_path": "", to something you want to load




#(overlook if done before)
#(create the list of training and testing file names)
#ls data/LJSpeech-1.1/wavs/*.wav | tail -n+10 > train_files.txt
#ls data/LJSpeech-1.1/wavs/*.wav | head -n10 > test_files.txt
#mkdir checkpoints
#cd ..




#(Finally start training)
#python train.py -c config.json
# OR
#python distributed.py -c config.json



