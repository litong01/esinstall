#!/usr/bin/env bash
# $1 public ip eth0
# $2 hostname

# Install git
apt-get -qqy update
apt-get -qqy install git

# Install Java, maven and gradle
source /onvm/scripts/install-java.sh
source /onvm/scripts/install-maven.sh
source /onvm/scripts/install-gradle.sh
