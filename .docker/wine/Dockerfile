# Use an appropriate base image like Debian or Ubuntu
FROM ubuntu:jammy as builder-config

# Avoiding user interaction
ENV DEBIAN_FRONTEND="noninteractive"

# Install necessary build dependencies
# RUN sed -i -E 's/^# deb-src /deb-src /g' /etc/apt/sources.list; \
#     apt-get update; \
#     apt-get install -y git; \
#     apt-get build-dep -y wine
# Install necessary build dependencies
RUN apt-get update -y; \
    dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install -y \
    wget software-properties-common apt-transport-https gnupg2 build-essential git\
    locales tzdata git vim curl ca-certificates \
    make gcc ccache gcc-multilib flex bison gcc-mingw-w64 pkg-config \
    libx11-dev:* libfreetype-dev:* \
    libxcursor-dev:* libxi-dev:* libxext-dev:* \
    libxxf86vm-dev:* libxrandr-dev:* libxinerama-dev:* \
    libxcomposite-dev:* libgl1-mesa-glx:* libgl1-mesa-dri:* \
    libosmesa6-dev:* libpcap-dev:* libdbus-1-dev:* libsane-dev:* \
    libusb-1.0-0-dev:* libv4l-dev:* libgphoto2-dev:* \
    liblcms2-dev:* libpulse-dev:* libgstreamer-plugins-base1.0-dev:* \
    libudev-dev:* libsdl2-dev:* libfaudio-dev:* \
    libcapi20-dev:* libcups2-dev:* libfontconfig-dev:* \
    libgsm1-dev:* libkrb5-dev:* libjxr-dev:* \
    libmpg123-dev:* libvulkan-dev:* \
    libvkd3d-dev:* libldap2-dev:* \
    libxml2-dev:* libxslt1-dev:* libgnutls28-dev:* \
    oss4-dev gettext gstreamer1.0-plugins-base:* gstreamer1.0-plugins-good:* \
     gstreamer1.0-plugins-bad:* gstreamer1.0-plugins-ugly:* gstreamer1.0-libav:*; \
    #fix broken packages
    apt --fix-broken install -y;\
    #clean
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*


# Clone the WineCX source code
WORKDIR /wine-source
# RUN git clone https://github.com/Gcenx/winecx .
RUN git config --global http.sslverify false;\
    git clone https://github.com/Gcenx/winecx .

# Set locale to avoid potential issues
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

#Build x64 wine
FROM builder-config as builder

# Configure WineCX
WORKDIR /wine-build
RUN /wine-source/configure --enable-win64;

#make and install wine64
RUN make -j "$(nproc)"
RUN mkdir -p /wine64-install; \
    make install DESTDIR=/wine64-install

RUN ls -l /wine64-install

# Set up the final container
FROM ubuntu:jammy

COPY --from=builder /wine64-install /