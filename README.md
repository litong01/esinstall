Introduction
============
This project installs elasticsearch (ES) onto multiple nodes.
one should download java 8, elasticsearch, kibana binaries and place
these files into a directory named leapbin at the same directory where this
project root directory is. Here is an example::

        leapbin
            elasticsearch-2.3.5.deb
            jdk-8u77-linux-x64.tar.gz
            kibana_4.5.4_amd64.deb
            logstash_2.3.4-1_all.deb
        esinstall
            ....

Having the structure like this will make the install goes faster. And when you
need to run the scripts repeatly, you won't need to keep downloading these
large files.


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
    # this design allows files to be synched just once per physical server
    synchfolder:
      folder: ./../esbin
      nodes: [master, data]


Above configuration, indicates that there are total of 3 physical nodes,
node01, node02 and node03. There are various logical nodes, the
logical2physical node section defines the mappings between logical and
physical node. These logical nodes are master node, kibana node and couple
data nodes. Master and kibana map to physical node node01 and datanode01 and
datanode02 map to node02 and node03 respectively. The synchfolder indicates
that folder relative to the root esbin will be also synched to logical master
and data nodes. This is to avoid synch files onto a physical node multiple
times.


Prepare your nodes accordingly then run the following two commands to deploy
elasticsearch and its components::

    vagrant up
    vagrant provision

If there is no error during the run, you should have elasticsearch system up
and running, you can access it by point your browser to the master node ip
address like the following::

    http://<<master_node_ip>>:9200
