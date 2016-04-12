#!/usr/bin/env bash

java_installed=$(which java)
if [ -z $java_installed ]; then
  if [ -f /esbin/jdk-8*-linux-x64.tar.gz ]; then
    mkdir -p /opt/jdk
    tar -zxf /esbin/jdk-*-linux-x64.tar.gz -C /opt/jdk
    mv /opt/jdk/* /opt/jdk/jdk1.8
    update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8/bin/java 100
    update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8/bin/javac 100
    echo 'Java install is now complete!'
  else
    echo 'Download java and place it in esbin directory.'
  fi
else
  echo 'Java has been installed!'
fi
