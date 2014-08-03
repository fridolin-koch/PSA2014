#
# Cookbook Name:: dns
# Recipe:: default
#
# (c) 2014 Fridolin Koch & Mattias Lang
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
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
    mode 0755
    action :create
  end

  directory "/var/cache/bind/back" do
    owner "bind"
    group "bind"
    mode 0755
    action :create
  end



  #our zones

  cookbook_file "/etc/bind/zones/db.psa-team1.informatik.tu-muenchen.de" do
   source "bind_zones_db.psa-team1.informatik.tu-muenchen.de"
   mode 0644
   owner "root"
   group "root"
  end

  cookbook_file "/etc/bind/zones/db.1.168.192" do
   source "bind_zones_db.1.168.192"
   mode 0644
   owner "root"
   group "root"
  end

  cookbook_file "/etc/bind/zones/db.psa-team21.informatik.tu-muenchen.de" do
   source "bind_zones_db.psa-team21.informatik.tu-muenchen.de"
   mode 0644
   owner "root"
   group "root"
  end

  cookbook_file "/etc/bind/zones/db.21.168.192" do
   source "bind_zones_db.21.168.192"
   mode 0644
   owner "root"
   group "root"
  end

  #team2

  service "bind9" do
    action :restart
  end

end
