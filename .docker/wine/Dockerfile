FROM ubuntu:jammy

ENV DEBIAN_FRONTEND="noninteractive"

# Install prerequisites
RUN apt-get update; \
        apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        cabextract \
        git \
        gnupg \
        gosu \
        gpg-agent \
        locales \
        p7zip \
        pulseaudio \
        pulseaudio-utils \
        sudo \
        tzdata \
        unzip \
        wget \
        winbind \
        xvfb \
        zenity; \
        rm -rf /var/lib/apt/lists/*

# Install wine
ARG WINE_BRANCH="staging"
RUN wget -nv -O- https://dl.winehq.org/wine-builds/winehq.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -; \
         echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(grep VERSION_CODENAME= /etc/os-release | cut -d= -f2) main" >> /etc/apt/sources.list; \
         dpkg --add-architecture i386; \
         apt-get update; \
         DEBIAN_FRONTEND="noninteractive" apt-get install -y --install-recommends winehq-${WINE_BRANCH}; \
         rm -rf /var/lib/apt/lists/*

# Install winetricks
RUN wget -nv -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks; \
     chmod +x /usr/bin/winetricks

# Download gecko and mono installers
COPY download_gecko_and_mono.sh /root/download_gecko_and_mono.sh
RUN chmod +x /root/download_gecko_and_mono.sh; \
     /root/download_gecko_and_mono.sh "$(wine --version | sed -E 's/^wine-//')"

# Configure locale for British/International English
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8

# Set the environment timezone to GMT
ENV TZ=UTC
ARG USERNAME=netris

#
#Create a non-root user `admin`
RUN apt-get update; \
    #
    #create a non-root user
    useradd --create-home --shell /bin/bash ${USERNAME};\
    usermod -a -G adm,audio,input,pulse-access,sudo,tape,tty,video ${USERNAME};\
    #
    #Remove sudo password
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#FIXME: do we need tini really? Wine needs to start subprocesses like the wineserver for it to work
# # Add Tini
# ARG TINI_VERSION=v0.19.0
# ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 /tini
# RUN chmod +x /tini

COPY entrypoint*.sh /
RUN chmod +x /entrypoint*.sh

VOLUME /var/run/appconfig

USER netris
WORKDIR /home/netris
# ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]