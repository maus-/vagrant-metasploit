#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------
MSF_PASSWORD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32})
MSF_PASSWORDTESTUSER=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32})
SYSTEM_RUBY_VERSION="ruby-2.1.3"
SYSTEM_RUBY_GEMSET="global"
MSF_PATH="/opt/metasploit"
VEIL_PATH="/opt/veil-evasion"
#----------------------------------------------------------------------------------------------------------------------
ubuntu_log_info ()
{
  RED="\033[0;31m"
  YELLOW="\033[0;33m"
  GREEN="\033[0;32m"
  GRAY="\033[1;30m"
  LIGHT_GRAY="\033[0;37m"
  CYAN="\033[0;36m"
  LIGHT_CYAN="\033[1;36m"
  NO_COLOUR="\033[0m"
  echo -e "$RED[*] $YELLOW$1$NO_COLOUR"
}
#----------------------------------------------------------------------------------------------------------------------
install_deps () 
{
  apt-get update
  apt-get -y upgrade
  apt-get -y install build-essential \
                     zlib1g \
                     zlib1g-dev \
                     libxml2 \
                     subversion \
                     libxml2-dev \
                     libxslt-dev \
                     locate \
                     libreadline6-dev \
                     libcurl4-openssl-dev \
                     git-core \
                     libssl-dev \
                     libyaml-dev \
                     openssl \
                     autoconf \
                     libtool \
                     ncurses-dev \
                     bison \
                     curl \
                     wget \
                     postgresql \
                     postgresql-contrib \
                     libpq-dev \
                     libapr1 \
                     libaprutil1 \
                     libsvn1 \
                     libpcap-dev \
                     postgresql-client \
                     htop \
                     unzip \
                     lsof \
                     git-core \
                     git \
                     vim \
                     gawk \
                     libsqlite3-dev \
                     sqlite3 \
                     libgdbm-dev \
                     libffi-dev \
                     tree \
                     python-crypto \

}
#----------------------------------------------------------------------------------------------------------------------
ubuntu_rvm ()
{
  curl -L https://get.rvm.io | sudo bash -s stable
  source /etc/profile.d/rvm.sh
  sudo usermod -a -G rvm $(whoami)
  rvm autolibs enable
  rvm install $SYSTEM_RUBY_VERSION
  rvm use $SYSTEM_RUBY_VERSION@$SYSTEM_RUBY_GEMSET --default --create
  ubuntu_log_info "Finished installing RVM!"
}
#----------------------------------------------------------------------------------------------------------------------
setup_postgres() 
{
  service postgresql start
  sudo -u postgres psql -c "CREATE USER msfuser WITH PASSWORD '$1';"
  sudo -u postgres psql -c "CREATE USER msftest WITH PASSWORD '$2';"
  sudo -u postgres psql -c "CREATE DATABASE metasploit_framework_development;"
  sudo -u postgres psql -c "CREATE DATABASE metasploit_framework_test;"
  sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE metasploit_framework_development to msfuser;"
  sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE metasploit_framework_test to msftest;"
}
#----------------------------------------------------------------------------------------------------------------------
setup_nmap() {
  svn co https://svn.nmap.org/nmap /tmp/nmap
  cd /tmp/nmap; /tmp/nmap/configure
  make
  make install
}
#----------------------------------------------------------------------------------------------------------------------
setup_msf () 
{ 
  cd $3
  bundle install
  for MSF in $(ls msf*); do
    echo "#!/usr/bin/env bash" > /usr/local/sbin/$MSF
    echo "rvm in $3 do $3/$MSF" >> /usr/local/sbin/$MSF
    chmod +x /usr/local/sbin/$MSF
  done
  cp $3/config/database.yml.example $3/config/database.yml
  sed -i 's/username: \metasploit_framework_development/username: msfuser/g' $3/config/database.yml
  sed -i 's/username: \metasploit_framework_test/username: msftest/g' $3/config/database.yml
  sed -i "s/__________________________________/$1/g" $3/config/database.yml
  sed -i "s/___________________________/$2/g" $3/config/database.yml
  echo "export MSF_DATABASE_CONFIG=$3/config/database.yml" >> ~/.bash_profile
  source ~/.bash_profile
}
#----------------------------------------------------------------------------------------------------------------------
setup_veil() 
{
  cd $1
  # Hack for prompt free install
  sed -i "s|read -p ' Continue With Installation? (y\/n): ' rootonly|rootonly=y|g" setup/setup.sh
  sed -i 's|raw_input(" [>] Please enter the path of your metasploit installation: ")|/opt/metasploit-framework|g' config/update.py 
  python Veil-Evasion.py
  sed -i 's|METASPLOIT_PATH="/opt/metasploit-framework"|METASPLOIT_PATH="/opt/metasploit"|g' /etc/veil/settings.py
  echo "METASPLOIT_PATH=$2" > /etc/veil/settings.py
  echo "#!/usr/bin/env bash 
  python $1/Veil-Evasion.py" > /usr/local/sbin/veil-evasion
  chmod +x /usr/local/sbin/veil-evasion
}
#----------------------------------------------------------------------------------------------------------------------
supbrah () {
  echo " __  __ ____  _____     "
  echo "|  \/  / ___||  ___|_   "
  echo "| |\/| \___ \| |_ _| |_ "
  echo "| |  | |___) |  _|_   _|"
  echo "|_|  |_|____/|_|   |_|  "
  echo "[*] MSF Location: $1"
  echo "[*] Veil Location: $2"
  echo "[*] msf* & veil executables already pathed into /usr/local/sbin"
  echo "[*] "
  echo "[!] NOTE: You will need to logout and log back in to finalize changes!!!"
  echo "[*] "
  echo "[*] Enjoy."
}
#----------------------------------------------------------------------------------------------------------------------

install_deps
ubuntu_rvm
setup_nmap &
source /etc/profile.d/rvm.sh
setup_postgres $MSF_PASSWORD $MSF_PASSWORDTESTUSER &
git clone https://github.com/rapid7/metasploit-framework $MSF_PATH &
git clone https://github.com/Veil-Framework/Veil-Evasion.git $VEIL_PATH
rvm install $(cat $MSF_PATH/.ruby-version)
setup_msf $MSF_PASSWORD $MSF_PASSWORDTESTUSER $MSF_PATH &
setup_veil $VEIL_PATH $MSF_PATH
supbrah $MSF_PATH $VEIL_PATH

