# Use an appropriate base image like Debian or Ubuntu
FROM ubuntu:jammy as builder-config

# Avoiding user interaction with tzdata
ENV DEBIAN_FRONTEND="noninteractive"

# Install necessary build dependencies
RUN sed -i -E 's/^# deb-src /deb-src /g' /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y git; \
    apt-get build-dep -y wine

# Clone the WineCX source code
WORKDIR /wine-source
RUN git clone https://github.com/Gcenx/winecx .

# Set locale to avoid potential issues
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV CC=clang
ENV CXX=clang
ENV CFLAGS="-I/usr/local/include"
ENV LDFLAGS="-L/usr/local/lib"

# Configure 32-bit WineCX
WORKDIR /wine-build
RUN /wine-source/configure

FROM builder-config as builder

RUN make -j "$(nproc)"
RUN mkdir -p /wine-install; \
    make install DESTDIR=/wine-install

RUN ls -l /wine-install

# Set up the final container
FROM ubuntu:jammy

COPY --from=builder /wine-install /