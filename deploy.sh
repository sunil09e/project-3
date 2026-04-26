#!/bin/bash

IMAGE_NAME=$1
IMAGE_TAG=$2

export IMAGE_NAME=$IMAGE_NAME
export IMAGE_TAG=$IMAGE_TAG

docker-compose pull
docker-compose up -d
