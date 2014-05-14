#!/bin/bash

while getopts ":e:p:" opt
do
  case "$opt" in
    e ) _ENVIRON=$OPTARG    ;;
    p ) _PROJECT=$OPTARG    ;;
  esac
done

if [[ $_ENVIRON = 'dev' ]]; then
    _USER='vagrant'
    _GROUP='vagrant'
else
    _USER='ubuntu'
    _GROUP='ubuntu'
fi

#==============================================================================
#  GitFS Requirements
#==============================================================================
# install git
apt-get install -y git

# GitPython uses setuptools in setup.py
wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
python ez_setup.py
rm -rf ez_setup.py setuptools*

# clone and isntall GitPython 0.3
git clone https://github.com/gitpython-developers/GitPython.git /tmp/gitpython
cd /tmp/gitpython
git checkout 0.3
python setup.py install
cd && rm -rf /tmp/gitpython/

#==============================================================================
#  Write salt configs to tmp dir
#==============================================================================
cat >/tmp/master <<EOL
user: $_USER

fileserver_backend:
  - roots
  - git

file_roots:
  base:
    - /srv/salt/base
  $_ENVIRON:
    - /srv/salt/$_ENVIRON

gitfs_remotes:
  - file:///states
  - https://github.com/ajw0100/salt-states.git

ext_pillar:
  - git: master file:///pillar
  - git: $_ENVIRON file:///pillar

EOL

cat >/tmp/minion <<EOL
master: localhost
id: $_PROJECT-master-$_ENVIRON

EOL
