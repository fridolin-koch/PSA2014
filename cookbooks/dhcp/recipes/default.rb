#
# Cookbook Name:: dhcp
# Recipe:: default
#
# Copyright 2014, Fridolin Koch, Matthias Lang
#

#install dhcp server
  package "isc-dhcp-server" do
    action :install
  end

#networking configuration
  template "/etc/dhcp/dhcpd.conf" do
    source "dhcp_conf.erb"
    mode 0644
    owner "root"
    group "root"
  end

execute "Start DHCP" do
    command "/etc/init.d/isc-dhcp-server restart"
    action :run
  end
