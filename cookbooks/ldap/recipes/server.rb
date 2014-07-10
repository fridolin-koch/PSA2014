#
# Cookbook Name:: ldap
# Recipe:: server
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
directory "/etc/ldap/ssl" do
  owner "openldap"
  group "openldap"
  mode 0700
  action :create
end

#taken from https://github.com/opscode-cookbooks/openldap/blob/master/recipes/server.rb

directory "/etc/ldap/slapd.d" do
  recursive true
  owner "openldap"
  group "openldap"
  action :create
end

execute "slapd-config-convert" do
  command "slaptest -f /etc/ldap/slapd.conf -F /etc/ldap/slapd.d/"
  user "openldap"
  action :nothing
  notifies :start, "service[slapd]", :immediately
end

#load data bag
ldap_secret = Chef::EncryptedDataBagItem.load_secret("/etc/chef/psa_databag_secret")
ldap_creds  = Chef::EncryptedDataBagItem.load("passwords", "ldap", ldap_secret)

template "/etc/ldap/slapd.conf" do
  source "slapd.conf.erb"
  mode 00640
  owner "openldap"
  group "openldap"
  notifies :stop, "service[slapd]", :immediately
  notifies :run, "execute[slapd-config-convert]"
  variables({
    :basedn => "dc=team01,dc=psa,dc=rbg,dc=tum,dc=de",
    :rootdn => ldap_creds['rootdn'],
    :rootpw => ldap_creds['rootpw']
  })
end

service "slapd" do
  action :start
end

