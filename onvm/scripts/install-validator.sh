#!/usr/bin/env bash
# $1 public ip eth0
# $2 hostname

source /onvm/scripts/yaml-config
load_yaml 'leap__' '/onvm/conf/nodes.conf.yml'

unicasthosts=''
masternodes=`get_yaml_values 'leap__' 'master'`
for nodename in $masternodes
do
  pname=`get_yaml_value 'leap__' 'logical2physical.'${nodename}`
  ip=`get_yaml_value 'leap__' ${pname}'.eth0'`
  if [ "$unicasthosts" ]; then
      unicasthosts+=",\"${ip}:9300\""
  else
      unicasthosts="\"${ip}:9300\""
  fi
done
unicasthosts=[$unicasthosts]
echo 'Unicast hosts are '$unicasthosts

set_yaml_value 'elastic__' 'discovery.zen.ping.unicast.hosts' "${unicasthosts}"
set_yaml_value 'elastic__' 'network.host' "$1"
set_yaml_value 'elastic__' 'network.description' 'Just something here'

echo 'Access the nodes and see the cluster'
curl -XGET "http://${ip}:9200/_nodes"