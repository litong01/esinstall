#!/usr/bin/env bash
# $1 public ip eth0
# $2 hostname

source /onvm/scripts/yaml-config
load_yaml 'leap__' '/onvm/conf/nodes.conf.yml'

# Java is required, install java first
source /onvm/scripts/install-java.sh

if [ -f /esbin/logstash-2.*.tar.gz ];then
  rm -r -f /opt/logstash /opt/leaptemp
  mkdir -p /opt/leaptemp

  tar -zxf /esbin/logstash-2.*.tar.gz -C /opt/leaptemp
  mv /opt/leaptemp/* /opt/logstash

  echo 'Logstash install is now complete!'
else
  echo 'Logstash binary was not found!'
  echo 'Download Logstash and configure the location in nodes.conf.yml file.'
fi
