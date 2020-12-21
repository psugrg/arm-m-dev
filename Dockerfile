# Use an official DDEN as a base image
FROM psugrg/dden:latest

# Set Development Environment name
ENV IMAGE_NAME="arm-m-dev"

# Set timezone. It's required by lots of packages. 
# It's also better than setting DEBIAN_FRINTEND=noninteractive since, in dev-environment
# somtimes interactive tools are needed.
ENV TZ=Europe/Warsaw
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install packages
RUN apt-get update && apt-get install -y \
        tar \ 
        wget \
        vim \
        mc \
        git \
        subversion \
        make \
        gcc-arm-none-eabi \ 
        gdb-multiarch \
        doxygen \
        graphviz \
        unzip \
        cppcheck \
        cmake \
        clang \
        clang-format \
        clang-tidy \
        clang-tools

# Set the working directory 
WORKDIR /opt

# Download CMSIS sources
ARG CMSIS_VERSION=5.7.0
RUN wget https://github.com/ARM-software/CMSIS_5/archive/${CMSIS_VERSION}.tar.gz \
  && tar -xzf ${CMSIS_VERSION}.tar.gz && rm ${CMSIS_VERSION}.tar.gz
# Set CMSISPATH (path to the CMSIS sources)
ENV CMSISPATH=/opt/CMSIS_${CMSIS_VERSION}/CMSIS

# Download FreeRTOS sources
ARG FREERTOS_VERSION=202012.00
RUN wget https://github.com/FreeRTOS/FreeRTOS/releases/download/${FREERTOS_VERSION}/FreeRTOSv${FREERTOS_VERSION}.zip
# Set FREERTOSPATH (path to the FreeRTOS sources)
ENV FREERTOSPATH=/opt/FreeRTOS-${FREERTOS_VERSION}/FreeRTOS

# Add user 

# Default values for the user and group
ARG USER_ID
ARG USER_NAME=user
ARG GROUP_ID
ARG GROUP_NAME=user

# Add new user
RUN groupadd -g ${GROUP_ID} ${GROUP_NAME} &&\
    useradd -l -u ${USER_ID} -g ${GROUP_NAME} ${USER_NAME} &&\
    install -d -m 0755 -o ${USER_NAME} -g ${GROUP_NAME} /home/${USER_NAME}

# Normally you woldn't add a docer user to the sudo group since a docer should be 
# a complete environment and adding anything in a runtime (apt get) is not a good idea. 
# Here hovewere the contaier is not ment to be used in production but is rather an example and/or a handfull tool to use when needed. 
# For this reason adding user to the sudo group can be handfull.
RUN apt-get update && apt-get install -y apt-utils sudo
RUN echo ${USER_NAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers 

# Change user
USER ${USER_NAME} 
WORKDIR /home/${USER_NAME}
