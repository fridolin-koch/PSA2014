#
# Cookbook Name:: dhcp
# Recipe:: default
#
# Copyright 2014, Fridolin Koch, Matthias Lang
#

#install dhcp server
  package "dhcp-3" do
    action :install
  end

#networking configuration
#  template "/etc/dhcp3/dhcpd.conf" do
#    source "dhcp3_conf.erb"
#    mode 0644
#    owner "root"
#    group "root"
#  end
