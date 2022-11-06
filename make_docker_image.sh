#!/bin/bash
docker build \
    --build-arg UBUNTU_VERSION=22.04 \
    --build-arg I2PD_VERSION=2.43.0 \
    --build-arg I2PD_COMPILER=gcc \
    --tag i2pd:2.43.0 \
    .
