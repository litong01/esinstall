#!/usr/bin/env bash
# $1 public ip eth0
# $2 hostname


source /onvm/scripts/yaml-config
load_yaml 'leap__' '/onvm/conf/nodes.conf.yml'

eshosts=[\'$(get_yaml_value 'leap__' 'elasticsearch.url')\']

# The following procedure installs packetbeat
apt-get -qqy update
apt-get -qqy install libpcap0.8
if [ ! -f /esbin/packetbeat_*.deb ];then
  mkdir -p /esbin
  curl -s -L https://download.elastic.co/beats/packetbeat/packetbeat_1.2.3_amd64.deb -o /esbin/packetbeat_1.2.3_amd64.deb
fi

dpkg -i /esbin/packetbeat_1.2.3_amd64.deb

echo 'Packetbeat has been installed!'

# configuring packetbeat /etc/packetbeat/packetbeat.yml
load_yaml 'packetbeat__' '/etc/packetbeat/packetbeat.yml'

set_yaml_value 'packetbeat__' 'output.elasticsearch.hosts' $eshosts
save_normal_yaml 'packetbeat__' '/etc/packetbeat/packetbeat.yml'

# The following procedure installs topbeat
if [ ! -f /esbin/topbeat_*.deb ];then
  mkdir -p /esbin
  curl -s -L https://download.elastic.co/beats/topbeat/topbeat_1.2.3_amd64.deb -o /esbin/topbeat_1.2.3_amd64.deb
fi

dpkg -i /esbin/topbeat_1.2.3_amd64.deb

# configuring topbeat /etc/topbeat/topbeat.yml
load_yaml 'topbeat__' '/etc/topbeat/topbeat.yml'
set_yaml_value 'topbeat__' 'output.elasticsearch.hosts' $eshosts
save_normal_yaml 'topbeat__' '/etc/topbeat/topbeat.yml'