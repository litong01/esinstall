#!/usr/bin/env bash
# $1 public ip eth0
# $2 hostname

source /onvm/scripts/yaml-config
load_yaml 'leap__' '/onvm/conf/nodes.conf.yml'

# Java is required, install java first
source /onvm/scripts/install-java.sh

if [ -f /esbin/logstash-2.*_all.deb ];then
  dpkg -i /esbin/logstash-2.*_all.deb

  masternodes=`get_yaml_values 'leap__' 'master'`
  for nodename in $masternodes
  do
    pname=`get_yaml_value 'leap__' 'logical2physical.'${nodename}`
    esip=`get_yaml_value 'leap__' ${pname}'.eth0'`
  done

  sed -i -e "s/ESIP/${esip}/g" /onvm/conf/logstash.conf
  cp /onvm/conf/logstash.conf /etc/logstash/conf.d/logstash.conf

  echo 'Logstash install is now complete!'
  service logstash restart
else
  echo 'Logstash binary was not found!'
  echo 'Download Logstash and configure the location in nodes.conf.yml file.'
fi
