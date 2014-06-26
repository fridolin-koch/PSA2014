#
# Cookbook Name:: fileserver
# Recipe:: default
#
# Copyright 2014, Fridolin Koch, Matthias Lang
#
# All rights reserved - Do Not Redistribute
#


#install nfs server
package "nfs-kernel-server" do
  action :install
end

#install smb
package "samba" do
  action :install
end

#nfs config
cookbook_file "/etc/exports" do
    source "etc_exports"
    mode 0644
    owner "root"
    group "root"
end

service "nfs-kernel-server" do
    action :restart
end

#smb server config
cookbook_file "/etc/samba/smb.conf" do
    source "smb.conf"
    mode 0644
    owner "root"
    group "root"
end

#smb users

service "samba" do
    action :restart
end
