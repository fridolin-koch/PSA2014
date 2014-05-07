#
# Cookbook Name:: base_utils
# Recipe:: default
#
# Copyright 2014, Fridolin Koch
#
# MIT

#we only support debian at this time
if node['platform'] == 'debian'

  #debian sources
  cookbook_file "/etc/apt/sources.list" do
    source "apt_sources.list"
    mode 0644
    owner "root"
    group "root"
  end
  
  execute "Adding dotdeb GPG-Key" do
    command "cd /root && wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg"
    action :run
  end
  
  execute "update apt sources" do
    command "aptitude update"
    action :run
  end
  
  #install utils
  #git
  package "git" do
    action :install
  end
  #svn
  package "subversion" do
    action :install
  end
  #htop
  package "htop" do
    action :install
  end
  #ruby
  package "ruby" do
    action :install
  end
  #vim
  package "vim" do
    action :install
  end
  #curl
  package "curl" do
    action :install
  end
  #sudo
  package "sudo" do
    action :install
  end
  #telnet
  package "telnet" do
    action :install
  end
  #xterm
  package "xterm" do
    action :install
  end
  #screen
  package "screen" do
    action :install
  end
  #ntp
  package "ntp" do
    action :install
  end
  #dig
  package "dnsutils" do
    action :install
  end
  
  
  #ssh server banner
  template "/etc/motd" do
    source "sshd_banner.erb"
    mode 0644
    owner "root"
    group "root"
  end
  
  #ssh server configuration
  cookbook_file "/etc/ssh/sshd_config" do
    source "sshd_config"
    mode 0644
    owner "root"
    group "root"
  end

  #restart ssh
  service "ssh" do
    action :restart
  end

  #ntp 
  cookbook_file "/etc/ntp.conf" do
    source "ntp.conf"
    mode 0644
    owner "root"
    group "root"
  end
  
  service "ntp" do
    action :restart
  end

  #bashrc
  cookbook_file "/root/.bashrc" do
    source "bashrc"
    mode 0644
    owner "root"
    group "root"
  end       

  #set shells
  cookbook_file "/etc/shells" do
    source "etc_shells"
    mode 0644
    owner "root"
    group "root"
  end
  
  #create ssh directory
  directory "/root/.ssh" do
    owner "root"
    group "root"
    mode 0700
    action :create
  end
  
  cookbook_file "/root/.ssh/authorized_keys" do
    source "root_authorized_keys"
    mode 0600
    owner "root"
    group "root"
  end
  
  #create users and groups
  group "psateam" do
    gid 1005
    action :create
  end
  
  #get psa team members
  psateam = data_bag_item('users', 'psateam')
  
  if psateam["users"]
    
    psateam["users"].each do |user|
    
      #only set the password once
      setPassword = !node["etc"]["passwd"].has_key?(user["name"])
      
      #create user
      user user["name"] do
        supports :manage_home => true
        uid user["id"]
        gid 1005
        home "/home/#{user['name']}"
        shell "/bin/bash"
      end
      
      if setPassword
        #change password and force the user to change it
        execute "Setting password for user #{user['name']}" do
            command "echo #{user['name']}:psa2014 | chpasswd && chage -d 0 #{user['name']}"
            action :run
        end
      end
      
    end
  end
  
  #networking configuration
  template "/etc/network/interfaces" do
    source "network_interfaces.erb"
    mode 0644
    owner "root"
    group "root"
  end
  
  execute "Restart network" do
    command "invoke-rc.d networking stop; sleep 2; invoke-rc.d networking start"
    action :run
  end

  
end
