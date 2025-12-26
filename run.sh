#!/bin/sh

docker run --rm -it --gpus all -v `pwd`/run:/comfy/mnt -v `pwd`/basedir:/basedir -v $HOME/keep/comfy:/basedir/output/video -e COMFY_CMDLINE_EXTRA=--highvram -e USE_UV=true -e WANTED_UID=`id -u` -e WANTED_GID=`id -g` -e BASE_DIRECTORY=/basedir -e SECURITY_LEVEL=normal -p 127.0.0.1:8188:8188 --name comfyui-nvidia comfyui-nvidia-docker:ubuntu24_cuda13.0 | grep -v 'lora key not loaded:'
