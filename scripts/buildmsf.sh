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
                     libgmp3-dev \
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
                     python-pip \

}
#----------------------------------------------------------------------------------------------------------------------
ubuntu_rvm ()
{
  # This == maximum clown!
  curl -sSL https://rvm.io/mpapis.asc | gpg --import -
  curl -L https://get.rvm.io | sudo bash -s stable
  source /etc/profile.d/rvm.sh
  export rvmsudo_secure_path=1
  echo "export rvmsudo_secure_path=1" >> $HOME/.bash_profile
  sudo usermod -a -G rvm $(whoami)
  rvm autolibs enable
  rvm install $SYSTEM_RUBY_VERSION --auto-dotfiles
  rvm use $SYSTEM_RUBY_VERSION@$SYSTEM_RUBY_GEMSET --default --create
  ubuntu_log_info "Finished installing RVM!"
}
#----------------------------------------------------------------------------------------------------------------------
clone_repos() 
{
 git clone https://github.com/rapid7/metasploit-framework $1 
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
  rvm install $(cat $MSF_PATH/.ruby-version) --auto-dotfiles
  cd $3
  gem install bundler
  rvmsudo bundle install
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
  sed -i "s|read -p ' Continue With Installation? (y\/n): ' rootonly|rootonly=y|g" $1/setup/setup.sh
  sed -i "s:msfpath =.*$:msfpath = '$2':" $1/config/update.py
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
  python $1/Veil-Evasion.py 
  sed -i "s|METASPLOIT_PATH='/opt/metasploit-framework'|METASPLOIT_PATH='$2'|g" /etc/veil/settings.py
  echo "METASPLOIT_PATH=$2" > /etc/veil/settings.py
  echo "#!/usr/bin/env bash 
  python $1/Veil-Evasion.py" > /usr/local/sbin/veil-evasion
  chmod +x /usr/local/sbin/veil-evasion
}
#----------------------------------------------------------------------------------------------------------------------
hello()
{
  echo ' ___________'
  echo '< 4d53462b >'
  echo '< 5665696c >'
  echo '< 383d3d44 >'
  echo ' -----------'
  echo '    \ '
  echo '    \'
  echo '                                   .::!!!!!!!:.'
  echo '  .!!!!!:.                        .:!!!!!!!!!!!!'
  echo '  ~~~~!!!!!!.                 .:!!!!!!!!!UWWW$$$ '
  echo '      :$$NWX!!:           .:!!!!!!XUWW$$$$$$$$$P '
  echo '      $$$$$##WX!:      .<!!!!UW$$$$"  $$$$$$$$# '
  echo '      $$$$$  $$$UX   :!!UW$$$$$$$$$   4$$$$$* '
  echo '      ^$$$B  $$$$\     $$$$$$$$$$$$   d$$R" '
  echo '        "*$bd$$$$      *$$$$$$$$$$$o+#" '
  echo '             """"          """"""" '
  echo "[*] MSF* executables already pathed into /usr/local/sbin"
  echo "[*] Call MSF* with 'rvmsudo msfconsole'"
  echo "[*] Enjoy."
}
#----------------------------------------------------------------------------------------------------------------------
base()
{
  install_deps
  ubuntu_rvm
  setup_nmap &
  source /etc/profile.d/rvm.sh
  setup_postgres $MSF_PASSWORD $MSF_PASSWORDTESTUSER &
  git clone https://github.com/rapid7/metasploit-framework $MSF_PATH
  setup_msf $MSF_PASSWORD $MSF_PASSWORDTESTUSER $MSF_PATH
}
#----------------------------------------------------------------------------------------------------------------------
extras()
{
  git clone https://github.com/Veil-Framework/Veil-Evasion.git $VEIL_PATH
  setup_veil $VEIL_PATH $MSF_PATH
}
#----------------------------------------------------------------------------------------------------------------------
# Lazy getops - whatever its bash.
case "$1" in
    extras)
        base
        extras
        hello $MSF_PATH $VEIL_PATH
        exit
        ;;
    *)
        base
        hello $MSF_PATH
        exit 
esac
