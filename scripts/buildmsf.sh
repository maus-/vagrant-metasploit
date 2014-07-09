#!/bin/bash
# I CAN MSF AND SO CAN YOU
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
  htop unzip lsof git-core vim
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

setup_postgres() {
  service postgresql start
  sudo -u postgres psql -c "CREATE USER msf WITH PASSWORD 'msfdev';"
  sudo -u postgres psql -c "CREATE database msf;"
  sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE msf to msf;"
}
wtf_msf () {
  git clone https://github.com/rapid7/metasploit-framework /opt/msf
  cd /opt/msf; bundle install
  for MSF in $(ls msf*); do ln -s /opt/metasploit-framework/$MSF /usr/local/bin/$MSF;done
  cp /vagrant/setup/database.yml /opt/msf/config/database.yml
}

supbrah () {
echo " __  __ ____  _____     ____  _______     __"
echo "|  \/  / ___||  ___|   |  _ \| ____\ \   / /"
echo "| |\/| \___ \| |_ _____| | | |  _|  \ \ / / "
echo "| |  | |___) |  _|_____| |_| | |___  \ V /  "
echo "|_|  |_|____/|_|       |____/|_____|  \_/   "
echo "happy msfing dev nonsense"
}

package_hell
dev_stuff
goddam_rvm
setup_postgres
wtf_msf
supbrah
