#
# Cookbook Name:: webserver
# Recipe:: default
#
# Copyright 2014, Fridolin Koch, Matthias Lang
#

#we only support debian at this time
if node['platform'] == 'debian'
  
  #install packages
  #nginx (dotdeb)
  package "nginx-common" do
    action :install
  end
  package "nginx-extras" do
    action :install
  end

  #php5.5 (dotdeb)
  package "php5-common" do
    action :install
  end
  package "php5-cli" do
    action :install
  end
  package "php5-curl" do
    action :install
  end
  package "php5-gd" do
    action :install
  end
  package "php5-mysql" do
    action :install
  end
  package "php5-sqlite" do
    action :install
  end
  package "php5-memcached" do
    action :install
  end
  package "php5-imagick" do
    action :install
  end
  package "php5-imap" do
    action :install
  end
  package "php5-json" do
    action :install
  end
  package "php5-xsl" do
    action :install
  end
  package "php5-mcrypt" do
    action :install
  end
  package "php5-intl" do
    action :install
  end
  package "php5-ldap" do
    action :install
  end
  #phpfpm
  package "php5-fpm" do
    action :install
  end
  
  
  
end