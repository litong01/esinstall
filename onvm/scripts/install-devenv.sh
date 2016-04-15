#!/usr/bin/env bash
# $1 public ip eth0
# $2 hostname

# Install git
apt-get -qqy update
apt-get -qqy install git

# Install Java, maven and gradle
source /onvm/scripts/install-java.sh
source /onvm/scripts/install-maven.sh
#source /onvm/scripts/install-gradle.sh

git clone https://github.com/datarank/tempest.git /opt/tempest
cd /opt/tempest
mvn clean package

echo 'Install the tempest plugin'
/usr/share/elasticsearch/bin/plugin -url file:///opt/tempest/target/releases/tempest-allocator-1.1.0.zip -install tempest

echo 'Reconfiguring Elasticsearch...'
source /onvm/scripts/yaml-config
load_yaml 'elastictemp__' '/etc/elasticsearch/elasticsearch.yml'
set_yaml_value 'elastictemp__' 'cluster.routing.allocation.type' 'com.datarank.tempest.allocator.LocalMinimumShardsAllocator'
set_yaml_value 'elastictemp__' 'cluster.routing.allocation.probabilistic.range_ratio' 1.5
set_yaml_value 'elastictemp__' 'cluster.routing.allocation.probabilistic.iterations' 3000

# Save the configuration file
save_yaml 'elastictemp__' '/etc/elasticsearch/elasticsearch.yml'

echo 'Restarting elasticsearch service...'
service elasticsearch restart
