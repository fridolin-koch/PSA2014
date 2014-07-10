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

#get psa team members
psateam = data_bag_item('users', 'psateam')

#nfs config
template "/etc/exports" do
    source "etc_exports.erb"
    mode 0644
    owner "root"
    group "root"
    variables({
      :users => psateam["users"]
    })
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

#mount user shares

if psateam["users"]
  psateam["users"].each do |user|
    if !user['mount'].nil?

      #create mount point
      directory "/fs/home/#{user['name']}" do
        owner user['id']
        group 1005
        mode 0755
        action :create
        not_if { ::File.directory?("/fs/home/#{user['name']}") }
      end

      #mount share
#      mount "/fs/home/#{user['name']}" do
#        device user['mount']
#        fstype "nfs"
#        options "rw,nosuid"
#        action [:mount, :enable]
#      end
    end
  end
end
