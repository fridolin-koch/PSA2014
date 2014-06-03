#
# Cookbook Name:: database
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.set['mysql']['server_root_password'] = 'yolo'

include_recipe 'mysql::server'