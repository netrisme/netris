FROM debian:buster

# Install desktop environment
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        pulseaudio && \
    rm -rf /var/lib/apt/lists/*

# Enable audio
RUN echo "load-module module-native-protocol-tcp auth-anonymous=1" >> /etc/pulse/default.pa

ENTRYPOINT /usr/bin/pulseaudio --system --verbose --log-target=stderr --realtime=true --disallow-exit -F /etc/pulse/default.pa