# syntax=docker/dockerfile:1
ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION} AS builder_i2pd
ARG I2PD_VERSION=2.45.0
ARG I2PD_COMPILER=gcc
RUN DEBIAN_FRONTEND=noninteractive\
    apt-get update &&\
    apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive\
    apt-get install -y $I2PD_COMPILER
RUN DEBIAN_FRONTEND=noninteractive\ 
    apt-get install -y \
    git \
    make \
    cmake \
    debhelper
RUN DEBIAN_FRONTEND=noninteractive\ 
    apt-get install -y \
    libboost-date-time-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libssl-dev \
    zlib1g-dev
RUN DEBIAN_FRONTEND=noninteractive\ 
    apt-get install -y \ 
    libminiupnpc-dev
WORKDIR /BUILD_I2PD/
RUN git clone --depth 1 --branch $I2PD_VERSION https://github.com/PurpleI2P/i2pd.git
WORKDIR /BUILD_I2PD/i2pd/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DWITH_AESNI=ON -DWITH_UPNP=ON .
RUN make

FROM ubuntu:${UBUNTU_VERSION}
RUN DEBIAN_FRONTEND=noninteractive\
    apt-get update &&\
    apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive\ 
    apt-get install -y \
    libboost-date-time-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libssl3 \
    zlib1g
RUN DEBIAN_FRONTEND=noninteractive\ 
    apt-get install -y \ 
    libminiupnpc17
# Ports Used by I2P
# Webconsole
EXPOSE 7070
# HTTP Proxy
EXPOSE 4444
# SOCKS Proxy
EXPOSE 4447
# SAM Bridge (TCP)
EXPOSE 7656
# BOB Bridge
EXPOSE 2827
# I2CP
EXPOSE 7654
# 7650
EXPOSE 7650
WORKDIR /I2PD/
COPY --from=builder_i2pd /BUILD_I2PD/i2pd/build/i2pd .
COPY --from=builder_i2pd /BUILD_I2PD/i2pd/contrib/certificates ./certificates
COPY i2pd.conf .
RUN ulimit -n 4096
CMD ["/I2PD/i2pd", "--datadir", "/I2PD", "--conf", "/I2PD/i2pd.conf"]