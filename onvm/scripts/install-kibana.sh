#!/usr/bin/env bash
# $1 public ip eth0
# $2 hostname

source /onvm/scripts/yaml-config
load_yaml 'leap__' '/onvm/conf/nodes.conf.yml'

# Java is required, install java first
source /onvm/scripts/install-java.sh

if [ -f /esbin/kibana-4.*-linux-x64.tar.gz ];then
  rm -r -f /opt/kibana
  mkdir -p /opt/kibana
  tar -zxf /esbin/kibana-4.*-linux-x64.tar.gz -C /opt/kibana
  mv /opt/kibana/* /opt/kibana/kibana

  es_url=`get_yaml_value 'leap__' 'elasticsearch.url'`
  echo 'ES URL for kibana is at '$es_url

  # Use the yaml-config library to config kibana parameters
  load_yaml 'kibana__' '/opt/kibana/kibana/config/kibana.yml'
  set_yaml_value 'kibana__' 'elasticsearch.url' $es_url
  save_yaml 'kibana__' '/opt/kibana/kibana/config/kibana.yml'
  del_yaml_values 'kibana__'

  # Start the kibana services
  start-stop-daemon --start --quiet --chuid root \
    --exec /opt/kibana/kibana/bin/kibana \
    --pidfile /opt/kibana/kibana.pid --make-pidfile --background >> /dev/null 2>&1

  echo 'Kibana install is now complete!'
else
  echo 'Kibana binary was not found!'
  echo 'Download kibana and  and configure the location in nodes.conf.yml file.'
fi
