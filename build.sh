#!/bin/bash

IMAGE_NAME=$1
IMAGE_TAG=$2

echo "Building image version $IMAGE_TAG"
docker build -t $IMAGE_NAME:$IMAGE_TAG .
