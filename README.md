Introduction
============
This project installs elasticsearch (ES) onto multiple nodes.
one should download java 8, elasticsearch, kibana binaries and place
these files into a directory named leapbin at the same directory where this
project root directory is. Here is an example::

        leapbin
            elasticsearch-2.3.0.deb
            jdk-8u77-linux-x64.tar.gz
            kibana-4.5.0-linux-x64.tar.gz
        esinstall
            ....

Having the structure like this will make the install goes faster. And when you
need to run the scripts repeatly, you won't need to keep downloading these
large files. The example directory leapbin above also lists the current
required software to run kiloeyes.


Usage:
======
You can install everything onto one machine or you can choose install different
components onto different servers. It is best to have various ES components
installed onto the separate machines. This vagrant project uses configuration
files in directory onvm/conf for installation. File nodes.conf.yml is
used to configure how many nodes will be used and how components will be
installed onto which node. File ids.conf.yml is used to save credentials to
access machines.

Here is an example::

    ---
    node01:
        hostname: node01.leap.dev
        eth0: 192.168.1.90

    node02:
        hostname: node02.leap.dev
        eth0: 192.168.1.93

    node03:
        hostname: node03.leap.dev
        eth0: 192.168.1.88

    logical2physical:
        master01: node01
        kibana01: node01
        datanode01: node02
        datanode02: node03

    elasticsearch:
        url: http://192.168.1.90:9200

    master:
        - master01

    data:
        - datanode01
        - datanode02

    kibana:
        - kibana01

    client:

    tribe:

    # the folder where some binaries reside will be synched onto the machines
    synchfolder: ./../esbin


Above configuration, indicates that there are total of 3 physical nodes,
node01, node02 and node03. There are various logical nodes, the
logical2physical node section defines the mappings between logical and
physical node. These logical nodes are master node, kibana node and couple
data nodes. Master and kibana map to physical node node01 and datanode01 and
datanode02 map to node02 and node03 respectively.


Prepare your nodes accordingly then run the following two commands to deploy
elasticsearch and its components::

    vagrant up
    vagrant provision
