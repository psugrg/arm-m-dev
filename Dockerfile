# Use an official DDEN as a base image
FROM psugrg/dden:latest

# Set Development Environment name
ENV IMAGE_NAME="arm-m-dev"

# Enable X11 forwarding by using the DDEN DOCKER_CREATE_EXTRA variable. 
# The content of this variable is called during the docker create action.
# This is required by the Ozone debugger (run directly from docker)
# Share USB devices to access target fia USB debugger
ENV DOCKER_CREATE_EXTRA="-e DISPLAY=\$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \ 
    -v /tmp/.docker.xauth:/tmp/.docker.xauth:rw -e XAUTHORITY=/tmp/.docker.xauth \
    --privileged -v /dev/bus/usb:/dev/bus/usb"

# Enable X11 forwarding by using the DDEN DOCKER_START_EXTRA variable. 
# The content of this variable is called during the docker start action.
ENV DOCKER_START_EXTRA="xauth nlist \$DISPLAY | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -"

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

# Install Segger JLink software pack
# Start from dependencies
RUN apt-get update && apt-get install -y \
  libncurses5 \
  libtinfo5
WORKDIR /tmp
# Copy the software pack from the current directory
COPY JLink_Linux* ./JLink_Linux.deb
# Install software pack
RUN dpkg -i JLink_Linux.deb

# Install Segger Ozone debugger
# Start from dependencies
RUN apt-get update && apt-get install -y \
  libxrandr2 \
  libxfixes3 \
  libxcursor1
# Copy the package containing the application
COPY Ozone_Linux* ./Ozone_Linux.deb
# Install debugger
RUN dpkg -i Ozone_Linux.deb

