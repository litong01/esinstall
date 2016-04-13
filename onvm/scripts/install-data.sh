#!/usr/bin/env bash
# $1 public ip eth0
# $2 hostname

source /onvm/scripts/yaml-config
load_yaml 'leap__' '/onvm/conf/nodes.conf.yml'

# Java is required, install java first
source /onvm/scripts/install-java.sh

if [ -f /esbin/elasticsearch-2.*.deb ];then
  dpkg -i /esbin/elasticsearch-2.*.deb

  clustername=`get_yaml_value 'leap__' 'elasticsearch.clustername'`
  echo 'Cluster name is '$clustername

  mkdir -p /var/elasticsearch/data /var/elasticsearch/log
  chown -R elasticsearch:elasticsearch /var/elasticsearch

  # Use the yaml-config library to config elasticsearch
  load_yaml 'elastic__' '/etc/elasticsearch/elasticsearch.yml'
  set_yaml_value 'elastic__' 'network.host' "$1"
  set_yaml_value 'elastic__' 'node.master' false
  set_yaml_value 'elastic__' 'node.data' true
  set_yaml_value 'elastic__' 'node.name' $2
  set_yaml_value 'elastic__' 'path.data' '/var/elasticsearch/data'
  set_yaml_value 'elastic__' 'path.log' '/var/elasticsearch/log'
  set_yaml_value 'elastic__' 'bootstrap.mlockall' true
  set_yaml_value 'elastic__' 'cluster.name' $clustername

  # Save the configuration file
  save_yaml 'elastic__' '/etc/elasticsearch/elasticsearch.yml'

  # Clean up the environment variables
  del_yaml_values 'elastic__'

  update-rc.d elasticsearch defaults
  service elasticsearch restart
  echo 'Elastic install is now complete!'
else
  echo 'Elasticsearch binary was not found!'
  echo 'Download elasticsearch and configure the location in nodes.conf.yml file.'
fi
