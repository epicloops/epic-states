# -*- mode: ruby -*-
# vi: set ft=ruby :

$project = "epic"
$salt_version = "v2014.1.0"
# Project-specific pillr data (AWS keys etc.) should be in a private git repo.
# This repo should be cloned and placed adjacent to the project directory on
# the filesystem.
$pillar_dir = "../#{$project}-pillar/"
# Make sure the following boxes are installed:
# PROVIDER: virtualbox
# vagrant box add precise64-20140512 http://cloud-images.ubuntu.com/vagrant/precise/20140512/precise-server-cloudimg-amd64-vagrant-disk1.box
# PROVIDER: aws
# vagrant box add precise64-20140512 --provider aws https://github.com/ajw0100/vagrant-boxes/raw/master/aws/precise64-20140512/precise64-20140512.box?raw=true
$box = "precise64-20140512"
# dev should be run on virtualbox
# qa and prod should be run on aws
$environments = ['dev', 'qa', 'prod']


$environments.each do |env|

  Vagrant.configure("2") do |config|

    config.vm.define "#{$project}-master-#{env}" do |node|
      node.vm.box = "#{$box}"
      node.vm.hostname = "#{$project}-master-#{env}"

      node.vm.synced_folder   ".",                 "/vagrant",                       type: "rsync",   disabled: true
      node.vm.synced_folder   ".",                 "/states",                        type: "rsync",   disabled: false
      node.vm.synced_folder   "#{$pillar_dir}",    "/pillar",                        type: "rsync",   disabled: false
      # if dev or qa pull project code from local repo.
      # otherwise we'll clone it from github during salt provision
      if ['dev', 'qa'].include? env
        node.vm.synced_folder   "../epiclib",      "/srv/salt/#{env}/epiclib",       type: "rsync",   disabled: false
        node.vm.synced_folder   "../epicbot",      "/srv/salt/#{env}/epicbot",       type: "rsync",   disabled: false
        node.vm.synced_folder   "../epicsampler",  "/srv/salt/#{env}/epicsampler",   type: "rsync",   disabled: false
      end

      node.vm.provision "shell" do |s|
        s.path = "pre-provision.sh"
        s.args = "-e #{env} -p #{$project}"
      end

      node.vm.provision :salt do |salt|
        salt.install_master = true
        salt.minion_key = "#{$pillar_dir}/preseed-keys/minion.pem"
        salt.minion_pub = "#{$pillar_dir}/preseed-keys/minion.pub"
        salt.seed_master = {"#{$project}-master-#{env}" => salt.minion_pub}
        # Bootstrap Options Below
        salt.bootstrap_script = "bootstrap-salt.sh"
        salt.bootstrap_options = "-X -c /tmp"
        # set to false if -X is passed above
        salt.run_highstate = false
        salt.install_type = "git"
        salt.install_args = $salt_version
        salt.always_install = true
        salt.verbose = true
      end

      node.vm.provision "shell" do |s|
        s.path = "post-provision.sh"
        s.args = "-e #{env} -p #{$project}"
      end

      node.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
      end

      if ['qa', 'prod'].include? env
        node.vm.provider :aws do |aws, override|
          aws.tags = { 'Name' => "#{$project}-master-#{env}" }
          aws.security_groups = ["#{$project}-master"]
          aws.instance_type = "c3.large"
        end
      end

    end

  end

end
