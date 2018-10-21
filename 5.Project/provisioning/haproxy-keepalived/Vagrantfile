Vagrant.configure(2) do |config|

  N = 2
  (1..N).each do |i|
    config.vm.define "haproxy#{i}" do |node|
      node.vm.box = "cent0s7"
      node.vm.synced_folder ".", "/vagrant", disabled: true
      node.vm.hostname = "haproxy#{i}"
      node.vm.network "private_network", ip:"10.0.26.20#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = "256"
        vb.name = "haproxy#{i}"
      end
      node.vm.provision "shell", path: "shell/iptables.sh"
      node.vm.provision "shell", inline: "service network restart"
    end
  end

  (1..N).each do |i|
    config.vm.define "web#{i}" do |app|
      app.vm.network "private_network", ip:"10.0.26.10#{i}"
      app.vm.hostname = "app#{i}"
      app.vm.box = "cent0s7"
      app.vm.synced_folder ".", "/vagrant", disabled: true
      app.vm.box_check_update = false
      app.vm.provider "virtualbox" do |vb|
        vb.memory = "256"
        vb.name = "web#{i}"
      end
      app.vm.provision "shell", path: "shell/iptables.sh"
      app.vm.provision "shell", inline: "service network restart"
  end
end

  config.vm.define "mgmt" do |mgmt|
      mgmt.vm.network "private_network", ip:"10.0.26.10"
      mgmt.vm.hostname = "mgmt"
      mgmt.vm.box = "cent0s7"
      mgmt.vm.synced_folder ".", "/vagrant", disabled: true
      mgmt.vm.box_check_update = false
      mgmt.vm.provider "virtualbox" do |vb|
        vb.memory = "256"
        vb.name = "mgmt"
      end
      mgmt.vm.provision "shell", inline: "service network restart"
      mgmt.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
      mgmt.vm.provision "file", source: "provision", destination: "/home/vagrant/"
      mgmt.vm.provision "shell", path: "shell/ansible-setup.sh"
  end
end