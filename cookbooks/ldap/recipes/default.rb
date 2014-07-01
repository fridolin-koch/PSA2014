#
# Cookbook Name:: ldap
# Recipe:: default
#
# Copyright 2014, Fridolin Koch, Matthias Lang
#

#install ldap
package "slapd" do
  action :install
end
package "ldap-utils" do
  action :install
end

#ldap config

cookbook_file "/etc/ldap/ldap.conf" do
 source "ldap.conf"
 mode 0644
 owner "root"
 group "root"
end

service "slapd" do
  action :restart
end
