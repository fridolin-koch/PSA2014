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
  
  #cert storage
  directory "/etc/nginx/certs" do
    owner "root"
    group "root"
    mode 0755
    action :create
  end
  
  #certs
  ["www.key", "www.pem", "www2.key", "www2.pem"].each do |file|
    cookbook_file "/etc/nginx/certs/#{file}" do
      source "nginx_certs_#{file}"
      mode 0644
      owner "root"
      group "root"
    end
  end
  
  #create www-root
  
  directory "/var/www" do
    owner "www-data"
    group "www-data"
    mode 0755
    action :create
  end
  
  #create subdirecories for each domain
  
  ["www", "www1", "www2"].each do |host|
    
    directory "/var/www/#{host}" do
      owner "www-data"
      group "www-data"
      mode 0755
      action :create
    end
    
    #create some index document
    template "/var/www/#{host}/index.html" do
      source "index.html.erb"
      mode 0644
      owner "www-data"
      group "www-data"
      variables({
        :host => "#{host}.psa-team1.informatik.tu-muenchen.de"
      })
    end
    
    #create site config
    cookbook_file "/etc/nginx/sites-available/#{host}" do
      source "nginx_site_#{host}"
      mode 0644
      owner "root"
      group "root"
    end
  
    #make links to enabled 
    link "/etc/nginx/sites-enabled/#{host}" do
      to "/etc/nginx/sites-available/#{host}"
    end
    
  end
  
  #restart nginx
  service "nginx" do
    action :restart
  end
  
end