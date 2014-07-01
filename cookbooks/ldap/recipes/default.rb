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

 source "ldap.conf"
 mode 0644
 owner "root"
 group "root"
end
