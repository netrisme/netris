FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive
#
# Add dependencies
RUN apt-get update -y; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
    wget \
    vim \
    software-properties-common \
    gpg-agent \
    jq \
    udev \
    xclip \
    x11-utils \
    xdotool \
    wmctrl \
     gdebi-core \
    x11-xserver-utils \
    xserver-xorg-core \
    libopus0 \
    libgdk-pixbuf2.0-0 \
    libsrtp2-1 \
    libxdamage1 \
    libxml2-dev \
    libwebrtc-audio-processing1 \
    libcairo-gobject2 \
    pulseaudio \
    libpulse0 \
    libpangocairo-1.0-0 \
    libgirepository1.0-dev; \
    #
    # Housekeeping
    apt-get clean -y; \
    rm -rf \
       /var/cache/debconf/* \
       /var/lib/apt/lists/* \
       /var/log/* \
       /tmp/* \
       /var/tmp/* \
       /usr/share/doc/* \
       /usr/share/man/* \
       /usr/share/local/*

RUN apt-get update -y; \
    apt-get upgrade -y; \
    add-apt-repository ppa:savoury1/ffmpeg4 \
    add-apt-repository ppa:savoury1/ffmpeg6 \
    apt-get update -y; \
    apt-get upgrade -y && apt-get dist-upgrade -y; \
    apt-get install ffmpeg -y; \
    #
    # Log out the ffmpeg version
    ffmpeg -version

#
#Download the latest Warp [CLIENT] linux binary
RUN wget -O warp https://github.com/wanjohiryan/warp/releases/latest/download/warp-ubuntu-amd64; \
    cp ./warp /usr/bin/ ;\
    rm ./warp

# Add Tini
ARG TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 /tini
RUN chmod +x /tini

COPY entrypoint*.sh /
RUN chmod +x /entrypoint*.sh

VOLUME /var/run/appconfig

ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]