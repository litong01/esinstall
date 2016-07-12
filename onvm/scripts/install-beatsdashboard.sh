#!/usr/bin/env bash
# $1 public ip eth0
# $2 hostname

source /onvm/scripts/yaml-config
load_yaml 'leap__' '/onvm/conf/nodes.conf.yml'

# If beats and kibana will be installed, then we go ahead enable the dashboard
if [[ "${leap__nodetypes[@]}" == *beats* && "${leap__nodetypes[@]}" == *kibana* ]]; then
  apt-get -qqy install unzip
  curl -s -L -O http://download.elastic.co/beats/dashboards/beats-dashboards-1.2.3.zip
  unzip beats-dashboards-1.2.3.zip
  cd beats-dashboards-1.2.3/
  ./load.sh -url http://$1:9200  > /dev/null 2>&1
fi
