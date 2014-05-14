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
#  Run master as non-root
#==============================================================================
# log dir is not created during bootstrap
mkdir -p /var/log/salt
chown -R $_USER:$_GROUP /etc/salt /var/cache/salt /var/log/salt

#==============================================================================
#  Start salt and run highstate
#==============================================================================
service salt-master start
service salt-minion start

sleep 10

salt '*' saltutil.sync_all
salt '*' state.highstate --verbose
