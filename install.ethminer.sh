#!/bin/bash
if [ ! -e cuda_9.2.148_396.37_linux ]
then
  echo "Downloading CUDA"
  wget https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux
  echo "Done"
fi

if [ ! -x cuda_9.2.148_396.37_linux ]
then
  echo "making file executable"
  chmod +x ./cuda_9.2.148_396.37_linux
fi

if [ -x cuda_9.2.148_396.37_linux ]
then
  echo "Installing driver" 
  ./cuda_9.2.148_396.37_linux --silent --override --driver
  echo "Installing toolkit"
  ./cuda_9.2.148_396.37_linux --silent --override --toolkit
  echo "Done"
fi

apt-get install gcc-6 g++-6

git clone https://github.com/ethereum-mining/ethminer
cd ethminer
git submodule update --init --recursive
mkdir build
cd build
cmake .. -DCMAKE_C_COMPILER=gcc-6 -DCMAKE_CXX_COMPILER=g++-6
cmake --build .
