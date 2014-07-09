#!/bin/bash
# BUILD MSF FO VAGRANT FO DEV PORPOSIES

package_hell () {
sudo apt-get update
sudo apt-get -y install \
  build-essential zlib1g zlib1g-dev \
  libxml2 libxml2-dev libxslt-dev locate \
  libreadline6-dev libcurl4-openssl-dev git-core \
  libssl-dev libyaml-dev openssl autoconf libtool \
  ncurses-dev bison curl wget postgresql \
  postgresql-contrib libpq-dev \
  libapr1 libaprutil1 libsvn1 \
  libpcap-dev git postgresql-client \
  htop unzip lsof git-core
}
dev_stuff () {
cp /vagrant/setup/bash_profile ~/.bash_profile
cp -rvf /vagrant/setup/vim ~/.vim
cp /vagrant/setup/vimrc ~/.vimrc
source ~/.bash_profile
}
goddam_rvm () {
  \curl -o rvm.sh -L get.rvm.io && cat rvm.sh | bash -s stable --autolibs=enabled --ruby=1.9.3
  source /etc/profile.d/rvm.sh
  source /etc/profile.d/rvm.sh
  sudo usermod -a -G rvm $(whoami)
} 

wtf_msf () {
  git clone https://github.com/rapid7/metasploit-framework /opt/msf
  cd /opt/msf; bundle install
}

todo () {
echo " __  __ ____  _____     ____  _______     __"
echo "|  \/  / ___||  ___|   |  _ \| ____\ \   / /"
echo "| |\/| \___ \| |_ _____| | | |  _|  \ \ / / "
echo "| |  | |___) |  _|_____| |_| | |___  \ V /  "
echo "|_|  |_|____/|_|       |____/|_____|  \_/   "
echo "Now you need to start postgres and setup msf users brohan, happy msfing"
}

package_hell
dev_stuff
goddam_rvm
wtf_msf
todo
