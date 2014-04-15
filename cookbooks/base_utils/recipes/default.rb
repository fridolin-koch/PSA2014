#
# Cookbook Name:: base_utils
# Recipe:: default
#
# Copyright 2014, Fridolin Koch
#
# MIT
#
if node['platform'] == 'debian'

  #debian sources
  cookbook_file "/etc/apt/sources.list" do
    source "apt_sources.list"
    mode 0644
    owner "root"
    group "root"
  end
  
  execute "update apt sources" do
    command "aptitude update"
    action :run
  end
  
  #install utils
  #git
  apt_package "git" do
    action :install
  end
  #svn
  apt_package "subversion" do
    action :install
  end
  #htop
  apt_package "htop" do
    action :install
  end
  #ruby
  apt_package "ruby" do
    action :install
  end
  #vim
  apt_package "vim" do
    action :install
  end
  #curl
  apt_package "curl" do
    action :install
  end
  #sudo
  apt_package "sudo" do
    action :install
  end
  #telnet
  apt_package "telnet" do
    action :install
  end
  #supervisor
  apt_package "supervisor" do
    action :install
  end
  #xterm
  apt_package "xterm" do
    action :install
  end
  #screen
  apt_package "screen" do
    action :install
  end
  #ntp
  apt_package "ntp" do
    action :install
  end
  

  #ssh server config
  template "/etc/motd" do
    source "sshd_banner.erb"
    mode 0644
    owner "root"
    group "root"
  end

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
  
end
