 
#!/bin/bash
git_repo=(
'https://github.com/rd235/s2argv-execs.git'
'https://github.com/rd235/cado.git'
'https://github.com/rd235/libpam-net.git'
'https://github.com/rd235/vdeplug4.git'
'https://github.com/rd235/libvdestack.git'
'https://github.com/rd235/vdens.git'
'https://github.com/rd235/nsutils.git'
'https://github.com/rd235/vde_dnsutils.git'
'https://github.com/rd235/libslirp.git'
'https://github.com/rd235/vdeplug_slirp.git'
'https://github.com/rd235/vxvdex.git'
'https://github.com/rd235/userbindmount.git'
)

case $1 in
  -u ) argv=u
  ;;
  -i ) mode="${git_repo[@]}"
  sudo apt install  linux-headers-$(uname -r) autotools-dev autoconf libmhash-dev libbsd-dev$
  argv="i"
  ;;
  * ) echo "usage: -u for update all repo, -i to install"
  exit
  ;;
esac
mkdir -p ~/VSD_tools
cd ~/VSD_tools
if [[ $argv == "u" ]]; then
    mode=$(ls)
fi
for i in $mode; do
  if [[ $argv  == "i" ]]; then
    git clone $i
    IFS='/ ' read -r -a array <<< "$i"
    i=${array[@]: -1}
    IFS='.' read -r -a array <<< "$i"
    i=${array[0]}
  fi
  cd $i;
  git pull
  if [[ $i == "vxvdex" ]]; then
    cd "kernel_module";
    make;
    sudo mkdir -p /lib/modules/$(uname -r)/kernel/misc;
    sudo cp vxvdex.ko /lib/modules/$(uname -r)/kernel/misc;
    sudo depmod -a;
    cd ../;
    cd "libvdeplug_vxvdex";
    autoreconf -if;
    ./configure;
    make;
    sudo make install;
    cd ../../;
  else
    autoreconf -if;
    ./configure;
    make;
    sudo make install;
    cd ../;
  fi
done
exit

