#!/bin/bash

# update apt cache, ingore "Release file... is not valid yet." error
apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false

# install git client and streamer, a camera capture tool
apt-get install -y git streamer



