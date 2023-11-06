FROM ubuntu:jammy

# Install base dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        xserver-xorg-core \
        x11-xserver-utils \
        xserver-xorg-input-evdev \
        xserver-xorg-input-libinput \
        xserver-xorg-input-kbd \
        xserver-xorg-video-dummy \
        xinput \
        evtest \
        socat \
        xvfb \
        dbus-x11 \
        libxrandr-dev \
        pciutils && \
    rm -rf /var/lib/apt/lists/

# Add Tini
ARG TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 /tini
RUN chmod +x /tini

# Remove libnss-systemd because it causes the dbus-daemon startup to hang for 90s.
RUN apt remove -y libnss-systemd

# Export library path for NVIDIA libs
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib64

# Set the DISPLAY variable.
ENV DISPLAY :0

# Set the PATH
ENV PATH ${PATH}:/usr/local/nvidia/bin

COPY xorg*.conf /etc/X11/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

VOLUME /var/run/appconfig

ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]