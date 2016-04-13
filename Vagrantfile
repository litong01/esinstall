# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

nodes = YAML.load_file("onvm/conf/nodes.conf.yml")
ids = YAML.load_file("onvm/conf/ids.conf.yml")

Vagrant.configure("2") do |config|
  config.vm.box = "tknerr/managed-server-dummy"
  config.ssh.username = ids['username']
  config.ssh.password = ids['password']

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "onvm", "/onvm", disabled: false, create: true
  config.vm.synced_folder nodes['synchfolder'], "/esbin", disabled: false, create:true

  node_types = ['master', 'data', 'client', 'kibana', 'tribe']
  node_types.each do | node_type |
    lnodes = nodes[node_type]
    if lnodes
      lnodes.each do |key|
        config.vm.define "#{key}" do |node|
          nodekey = nodes['logical2physical'][key]

          node.vm.provider :managed do |managed|
            managed.server = nodes[nodekey]['eth0']
          end

          node.vm.provision "#{key}-install", type: "shell" do |s|
            s.path = "onvm/scripts/install-" + node_type + ".sh"
            s.args = nodes[nodekey]['eth0'] + ' ' + nodes[nodekey]['hostname']
          end
        end
      end
    end
  end

end
