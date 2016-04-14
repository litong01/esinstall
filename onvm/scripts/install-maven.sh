#!/usr/bin/env bash

mvn_installed=$(which mvn)
if [ -z $mvn_installed ]; then
  if [ -f /esbin/apache-maven-3.*-bin.tar.gz ]; then
    rm -r -f /opt/maven /opt/leaptemp
    mkdir -p /opt/leaptemp
    tar -zxf /esbin/apache-maven-3.*-bin.tar.gz -C /opt/leaptemp
    mv /opt/leaptemp/* /opt/maven
    rm -r -f /opt/leaptemp

    export M2_HOME=/opt/maven
    export PATH=$PATH:$M2_HOME/bin

    echo 'Maven install is now complete!'
  else
    echo 'Download maven and place it in esbin directory.'
  fi
else
  echo 'Maven has been installed!'
fi
