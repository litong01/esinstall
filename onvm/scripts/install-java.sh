#!/usr/bin/env bash

java_installed=$(which java)
if [ -z $java_installed ]; then
  if [ -f /esbin/jdk-8*-linux-x64.tar.gz ]; then
    rm -r -f /opt/jdk8 /opt/leaptemp
    mkdir -p /opt/leaptemp
    tar -zxf /esbin/jdk-*-linux-x64.tar.gz -C /opt/leaptemp
    mv /opt/leaptemp/* /opt/jdk8
    update-alternatives --install /usr/bin/java java /opt/jdk8/bin/java 100
    update-alternatives --install /usr/bin/javac javac /opt/jdk8/bin/javac 100
    echo 'Java install is now complete!'
  else
    echo 'Download java and place it in esbin directory.'
  fi
else
  echo 'Java has been installed!'
fi
