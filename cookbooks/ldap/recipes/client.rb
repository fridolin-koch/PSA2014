#
# Cookbook Name:: ldap
# Recipe:: client
#
# Copyright 2014, Fridolin Koch, Matthias Lang
#

#ldap client and pam
package "libpam-ldap" do
  action :purge
end

package "libnss-ldap" do
  action :purge
end

package "nslc" do
  action :purge
end

package "libpam-ldapd" do
  action :install
end



#load data bag
ldap_secret = Chef::EncryptedDataBagItem.load_secret("/etc/chef/psa_databag_secret")
ldap_creds  = Chef::EncryptedDataBagItem.load("passwords", "ldap", ldap_secret)

#other ldap config
template "/etc/ldap.conf" do
  source "ldap.conf.erb"
  mode 00644
  owner "root"
  group "root"
  variables({
    :basedn => "dc=team01,dc=psa,dc=rbg,dc=tum,dc=de",
  })
end

cookbook_file "/etc/ldap/ldapCert.pem" do
  source "ldapCert.pem"
  mode 00644
  owner "root"
  group "root"
end

template "/etc/ldap/ldap.conf" do
  source "ldap-ldap.conf.erb"
  mode 00644
  owner "root"
  group "root"
  variables({
    :basedn => "dc=team01,dc=psa,dc=rbg,dc=tum,dc=de",
  })
end

#nslcd


cookbook_file "/etc/nsswitch.conf" do
  source "nsswitch.conf"
  mode 00644
  owner "root"
  group "root"
end

template "/etc/nslcd.conf" do
  source "nslcd.conf.erb"
  mode 00644
  owner "root"
  group "root"
  variables({
    :basedn => "dc=team01,dc=psa,dc=rbg,dc=tum,dc=de",
  })
end

#pam
%w{ account auth password session }.each do |pam|
  cookbook_file "/etc/pam.d/common-#{pam}" do
    source "common-#{pam}"
    mode 00644
    owner "root"
    group "root"
    notifies :restart, "service[ssh]", :delayed
  end
end