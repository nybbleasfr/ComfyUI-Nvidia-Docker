#!/bin/bash

# Pre-requisites (run first):
# - 00-nvidiaDev.sh

# Install xformers
# 
# https://github.com/facebookresearch/xformers

echo "** Installing xformers**"

set -e

error_exit() {
  echo -n "!! ERROR: "
  echo $*
  echo "!! Exiting script (ID: $$)"
  exit 1
}

source /comfy/mnt/venv/bin/activate || error_exit "Failed to activate virtualenv"

# We need both uv and the cache directory to enable build with uv
use_uv=true
uv="/comfy/mnt/venv/bin/uv"
uv_cache="/comfy/mnt/uv_cache"
if [ ! -x "$uv" ] || [ ! -d "$uv_cache" ]; then use_uv=false; fi

cd /comfy/mnt
bb="venv/.build_base.txt"
if [ ! -f $bb ]; then error_exit "${bb} not found"; fi
BUILD_BASE=$(cat $bb)
# ubuntu24_cuda12.9
# extract CUDA version from build base
CUDA_VERSION=$(echo $BUILD_BASE | grep -oP 'cuda\d+\.\d+')
if [ -z "$CUDA_VERSION" ]; then error_exit "CUDA version not found in build base"; fi

echo "CUDA version: $CUDA_VERSION"

if [ "A$use_uv" == "Atrue" ]; then
  if [ -z "${UV_TORCH_BACKEND+x}" ]; then error_exit "UV_TORCH_BACKEND is not set"; fi
  echo "== Using uv"
  echo " - uv: $uv"
  echo " - uv_cache: $uv_cache"
  echo " - UV_TORCH_BACKEND: $UV_TORCH_BACKEND"
  uv pip install xformers || error_exit "Failed to uv install xformers"
else
  if [ -z "${TORCH_INDEX_URL+x}" ]; then error_exit "TORCH_INDEX_URL is not set"; fi
  echo "== Using pip"
  echo " - TORCH_INDEX_URL: $TORCH_INDEX_URL"
  pip3 install xformers --index-url $TORCH_INDEX_URL || error_exit "Failed to install xformers"
fi

exit 0
