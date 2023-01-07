# I2PD-DOCKER

## Description

This project is a set of tools for building [I2PD](https://i2pd.website/) docker images. 

## Building

You can build I2PD docker image by simply run script *make_docker_image.sh*. 
Feel free to modify it with your own building arguments.

## Running

To run I2PD docker container just execute this from command line

> docker run --rm -d  -p 2827:2827/tcp -p 4444:4444/tcp -p 4447:4447/tcp -p 7070:7070/tcp -p 7650:7650/tcp -p 7654:7654/tcp -p 7656:7656/tcp i2pd:2.45.0

## Deploy

To deploy built image to your host just execute this from command line

> docker save i2pd:2.45.0 | bzip2 | pv | ssh user@host docker load