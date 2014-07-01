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
