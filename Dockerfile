FROM nvidia/cuda:10.2-cudnn7-devel-centos7

LABEL opensciencegrid.name="EL 7 CUDA 10"
LABEL opensciencegrid.description="Enterprise Linux (CentOS) 7 base image, with CUDA 10"
LABEL opensciencegrid.url="https://developer.nvidia.com/cuda-toolkit"
LABEL opensciencegrid.category="Base"
LABEL opensciencegrid.definition_url="https://github.com/opensciencegrid/osgvo-el7-cuda10"

RUN yum -y install epel-release yum-plugin-priorities

# osg repo
RUN yum -y install http://repo.opensciencegrid.org/osg/3.6/osg-3.6-el7-release-latest.rpm
   
# well rounded basic system to support a wide range of user jobs
RUN yum -y groups mark convert \
    && yum -y grouplist \
    && yum -y groupinstall "Compatibility Libraries" \
                           "Development Tools" \
                           "Scientific Support"

RUN yum -y install \
           astropy-tools \
           bc \
           binutils \
           binutils-devel \
           cmake \
           coreutils \
           curl \
           davix-devel \
           dcap-devel \
           doxygen \
           dpm-devel \
           fontconfig \
           gcc \
           gcc-c++ \
           gcc-gfortran \
           git \
           glew-devel \
           glib2-devel \
           glib2-devel \
           glib-devel \
           globus-gass-copy-devel \
           graphviz \
           gsl-devel \
           gtest-devel \
           java-1.8.0-openjdk \
           java-1.8.0-openjdk-devel \
           json-c-devel \
           lfc-devel \
           libattr-devel \
           libgfortran \
           libGLU \
           libgomp \
           libicu \
           libquadmath \
           libssh2-devel \
           libtool \
           libtool-ltdl \
           libtool-ltdl-devel \
           libuuid-devel \
           libX11-devel \
           libXaw-devel \
           libXext-devel \
           libXft-devel \
           libxml2 \
           libxml2-devel \
           libXmu-devel \
           libXpm \
           libXpm-devel \
           libXt \
           mesa-libGL-devel \
           nano \
           numpy \
           octave \
           octave-devel \
           openldap-devel \
           openssh \
           openssh-server \
           openssl098e \
           osg-wn-client \
           p7zip \
           p7zip-plugins \
           python-astropy \
           python-devel \
           R-devel \
           redhat-lsb \
           redhat-lsb-core \
           rsync \
           scipy \
           srm-ifce-devel \
           stashcache-client \
           subversion \
           tcl-devel \
           tcsh \
           time \
           tk-devel \
           vim \
           wget \
           xrootd-client-devel \
           zlib-devel \
           which

# htcondor - include so we can chirp
RUN yum -y install condor

# Cleaning caches to reduce size of image
RUN yum clean all

# required directories
RUN for MNTPOINT in \
        /cvmfs \
        /hadoop \
        /ceph \
        /hdfs \
        /lizard \
        /mnt/hadoop \
        /mnt/hdfs \
        /xenon \
        /spt \
        /stash2 \
    ; do \
        mkdir -p $MNTPOINT ; \
    done

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /etc/OpenCL/vendors

ENV PS1="Singularity \$SINGULARITY_NAME:\\w> "
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/.singularity.d/libs
ENV PATH=/usr/local/cuda/bin:/usr/local/bin:/usr/bin:/bin

# some extra singularity stuff
COPY osg-labels.json /

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

