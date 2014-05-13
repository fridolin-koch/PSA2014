#
# Cookbook Name:: dns
# Recipe:: default
#
# Copyright 2014, Fridolin Koch, Matthias Lang
#

#we only support debian at this time
if node['platform'] == 'debian'
  
  #install bind9
  package "bind9" do
    action :install
  end
  
  package "bind9utils" do
    action :install
  end
  
  #bind config files
  
  cookbook_file "/etc/bind/named.conf.options" do
   source "bind_named.conf.options"
   mode 0644
   owner "root"
   group "root"
  end
  
  cookbook_file "/etc/bind/named.conf.local" do
   source "bind_named.conf.local"
   mode 0644
   owner "root"
   group "root"
  end
  
  #create zones directory
  directory "/etc/bind/zones" do
    owner "root"
    group "root"
    mode 0700
    action :create
  end
  
  service "bind9" do
    action :restart
  end
  
end