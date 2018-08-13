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
  echo "Killing X Server"
  service lightdm stop
  service gdm stop
  service gdm3 stop
  service kdm stop
  echo "Purging extant nVidia drivers and utils"
  apt-get --assume-yes purge nvidia*
  apt-get --assume-yes autoremove
  echo "Blacklisting Nouveau Driver"
  echo "blacklist nouveau" > /etc/modprobe.d/blacklist-nouveau.conf
  echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
  update-initramfs -u
  echo "Installing driver... this may take a while" 
  ./cuda_9.2.148_396.37_linux --silent --override --driver --no-opengl-libs --run-nvidia-xconfig
  echo "Installing toolkit... this may take a while"
  ./cuda_9.2.148_396.37_linux --silent --override --toolkit
  echo "Done"
fi

apt-get --assume-yes install gcc-6 g++-6 cmake build-essential

git clone https://github.com/ethereum-mining/ethminer
cd ethminer
git submodule update --init --recursive
mkdir build
cd build
cmake .. -DCMAKE_C_COMPILER=gcc-6 -DCMAKE_CXX_COMPILER=g++-6
cmake --build .

echo "Starting X Server"
service lightdm start
service gdm start
service gdm3 start
service kdm start
