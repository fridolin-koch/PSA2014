#
# Cookbook Name:: database
# Recipe:: salve
#
# Copyright 2014, Fridolin Koch, Matthias Lang
#

#load data bag
mysql_secret = Chef::EncryptedDataBagItem.load_secret("/etc/chef/psa_databag_secret")
mysql_creds = Chef::EncryptedDataBagItem.load("passwords", "mysql", mysql_secret)

node.set['mysql']['server_root_password'] = mysql_creds['root_password']

include_recipe 'mysql::server'