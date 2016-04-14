#!/usr/bin/env bash

gradle_installed=$(which gradle)
if [ -z $gradle_installed ]; then
  if [ -f /esbin/gradle-2.*-bin.zip ]; then
    apt-get -qqy install unzip
    rm -r -f /opt/gradle /opt/leaptemp
    mkdir -p /opt/leaptemp
    cd /opt/leaptemp
    unzip /esbin/gradle-2.*-bin.zip
    cd ~
    mv /opt/leaptemp/* /opt/gradle
    rm -r -f /opt/leaptemp

    export GRADLE_HOME=/opt/gradle
    export PATH=$PATH:$GRADLE_HOME/bin

    echo 'Gradle install is now complete!'
  else
    echo 'Download gradle and place it in esbin directory.'
  fi
else
  echo 'Gradle has been installed!'
fi
