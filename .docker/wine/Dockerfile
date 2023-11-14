# Use an appropriate base image like Debian or Ubuntu
FROM ubuntu:jammy as builder

# Avoiding user interaction with tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary build dependencies
RUN dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install -y \
    wget \
    software-properties-common \
    apt-transport-https \
    gnupg2 \
    build-essential \
    git \
    gcc \
    make \
    flex \
    bison \
    libx11-dev \
    libfreetype6-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libgnutls28-dev \
    libjpeg-dev \
    libpng-dev \
    libosmesa6-dev \
    libsdl2-dev \
    libvkd3d-dev \
    libxcomposite-dev \
    libxcursor-dev \
    libxi-dev \
    libxinerama-dev \
    libxrandr-dev \
    libxslt1-dev \
    libxxf86vm-dev \
    libvulkan1 \
    libvulkan-dev \
    libudev-dev \
    libpcap0.8-dev \
    libdbus-1-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libpulse-dev \
    libcapi20-dev \
    libmpg123-dev \
    libopenal-dev \
    libldap2-dev \
    libsane-dev \
    libv4l-dev \
    ocl-icd-opencl-dev \
    libgphoto2-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libxml2-dev \
    libxslt1-dev \
    libgnutls28-dev \
    libjpeg-dev \
    libxml2-dev \
    libtiff-dev \
    prelink \
    libtiff5-dev \
    libpng-dev \
    libssl-dev \
    libcups2-dev \
    libfreetype6-dev \
    libfontconfig1-dev \
    libgsm1-dev \
    libkrb5-dev \
    libmpg123-dev \
    libgstreamer-plugins-base1.0-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libavfilter-dev; \
    rm -rf /var/lib/apt/lists/*

# Clone the WineCX source code
RUN git clone https://github.com/Gcenx/winecx.git /wine-source
WORKDIR /wine-source

# Configure and compile WineCX
# Note: you may want to run the configure script with specific flags depending on your requirements
RUN mkdir -p /wine-install; \
    ./configure; \
    make -j$(nproc); \
    make install DESTDIR=/wine-install

# Set locale to avoid potential issues
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# Set up the final container
FROM ubuntu:jammy

COPY --from=builder /wine-install /