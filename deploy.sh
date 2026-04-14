#!/bin/bash

IMAGE_NAME=$1
IMAGE_TAG=$2

export IMAGE_NAME=$IMAGE_NAME
export IMAGE_TAG=$IMAGE_TAG

sudo docker-compose pull
sudo docker-compose up -d
