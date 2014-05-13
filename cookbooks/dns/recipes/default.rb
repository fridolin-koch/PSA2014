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
  
end