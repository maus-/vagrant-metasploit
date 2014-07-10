#!/bin/bash
# I CAN MSF AND SO CAN YOU
LOLPASSWORD=$(head -n1000 /dev/urandom | strings | grep -o '[[:alnum:]]' | head -n 32 | tr -d '\n'; echo)
LOLPASSWORDTESTUSER=$(head -n1000 /dev/urandom | strings | grep -o '[[:alnum:]]' | head -n 32 | tr -d '\n'; echo)
RUBY_VERSION="ruby-1.9.3-p547"
MSFPATH="/opt/msf"

install_deps () {
  apt-get update;
# Obviously more than MSF.
apt-get -y install \
build-essential zlib1g zlib1g-dev libxml2 subversion libxml2-dev libxslt-dev locate libreadline6-dev libcurl4-openssl-dev git-core libssl-dev libyaml-dev openssl autoconf libtool ncurses-dev bison curl wget postgresql postgresql-contrib libpq-dev libapr1 libaprutil1 libsvn1 libpcap-dev git postgresql-client htop unzip lsof git-core vim  gawk libsqlite3-dev sqlite3 libgdbm-dev libffi-dev tree
}

setup_rvm () {
  \curl -o rvm.sh -L get.rvm.io && cat rvm.sh | bash -s stable --autolibs=enabled --ruby=$1
  source /etc/profile.d/rvm.sh
  rvm --default use $1  
  sudo usermod -a -G rvm $(whoami)
} 

setup_postgres() {
  service postgresql start
  sudo -u postgres psql -c "CREATE USER msfuser WITH PASSWORD '$1';"
  sudo -u postgres psql -c "CREATE USER msftest WITH PASSWORD '$2';"
  sudo -u postgres psql -c "CREATE database metasploit_framework_development;"
  sudo -u postgres psql -c "CREATE database metasploit_framework_test;"
  sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE metasploit_framework_development to msfuser;"
  sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE metasploit_framework_test to msftest;"
}

setup_nmap() {
  svn co https://svn.nmap.org/nmap /tmp/nmap
  cd /tmp/nmap; /tmp/nmap/configure
  make
  make install
}
setup_msf () {
git clone https://github.com/rapid7/metasploit-framework $3
  cd $3; bundle install
  rvm gemset use metasploit-framework --default
  for MSF in $(ls msf*)
   do ln -s $3/$MSF /usr/local/sbin/$MSF
  done
  cp $3/config/database.yml.example $3/config/database.yml
  sed -i 's/username: \metasploit_framework_development/username: msfuser/g' $3/config/database.yml
  sed -i 's/username: \metasploit_framework_test/username: msftest/g' $3/config/database.yml
  sed -i "s/__________________________________/$1/g" $3/config/database.yml
  sed -i "s/___________________________/$2/g" $3/config/database.yml
  echo "export MSF_DATABASE_CONFIG=$3/config/database.yml" >> ~/.bash_profile
  source ~/.bash_profile
}

supbrah () {
  echo " __  __ ____  _____ "
  echo "|  \/  / ___||  ___|"
  echo "| |\/| \___ \| |_   "
  echo "| |  | |___) |  _|  "
  echo "|_|  |_|____/|_|    "
  echo "Happy MSF nonsense  "
}

install_deps
setup_rvm $RUBY_VERSION
setup_postgres $LOLPASSWORD $LOLPASSWORDTESTUSER
setup_nmap
setup_msf $LOLPASSWORD $LOLPASSWORDTESTUSER $MSFPATH
supbrah $MSFPATH
