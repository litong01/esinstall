# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

nodes = YAML.load_file("onvm/conf/nodes.conf.yml")
ids = YAML.load_file("onvm/conf/ids.conf.yml")

Vagrant.configure("2") do |config|
  config.vm.box = "tknerr/managed-server-dummy"
  config.ssh.username = ids['username']
  if ids['private_key_path']
    config.ssh.private_key_path = ids['private_key_path']
  elsif ids['password']
    config.ssh.password = ids['password']
  else
    puts 'No private key or password defined! Config VM credentials in onvm/conf/ids.conf.yml file'
    exit(1)
  end
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "onvm", "/onvm", disabled: false, create: true

  nodetypes = nodes['nodetypes']
  nodetypes.each do | nodetype |
    lnodes = nodes[nodetype]
    if lnodes
      lnodes.each do |key|
        config.vm.define "#{key}" do |node|
          nodekey = nodes['logical2physical'][key]

          node.vm.provider :managed do |managed|
            managed.server = nodes[nodekey]['eth0']
          end

          if nodes['synchfolder']['nodes'].index(nodetype)
            node.vm.synced_folder nodes['synchfolder']['folder'], "/esbin", disabled: false, create: true
          end

          node.vm.provision "#{key}-install", type: "shell" do |s|
            s.path = "onvm/scripts/install-" + nodetype + ".sh"
            s.args = nodes[nodekey]['eth0'] + ' ' + nodes[nodekey]['hostname']
          end
        end
      end
    end
  end

end
