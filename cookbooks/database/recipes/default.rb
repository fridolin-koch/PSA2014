#
# Cookbook Name:: database
# Recipe:: master
#
# Copyright 2014, Fridolin Koch, Matthias Lang
#

#load data bag
mysql_secret = Chef::EncryptedDataBagItem.load_secret("/etc/chef/psa_databag_secret")
mysql_creds  = Chef::EncryptedDataBagItem.load("passwords", "mysql", mysql_secret)

node.set['mysql']['server_root_password'] = mysql_creds['root_password']

include_recipe 'mysql::server'

#is master?
master = node['mysql']['type'] == 'master'

#mysql config 
template '/etc/mysql/conf.d/master-slave.cnf' do
  source 'my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables({
    :master => master
  })
end

service "mysql" do
  action :restart
end

#init database
template '/etc/mysql/init.sql' do
  source 'init.sql.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables({
    :creds => mysql_creds,
    :master => master
  })
end
 
execute "Executing /etc/mysql/mysql_defaults.sql" do
  command "mysql -u root -p#{mysql_creds['root_password']} < /etc/mysql/init.sql"
  action :run
end

#backup
if !master 
  
  #create backup dir
  directory node['mysql']['backup_dir'] do
    owner "root"
    group "root"
    mode 0700
    action :create
  end
  
  #cron log direcotry
  directory '/var/log/cron' do
    owner "root"
    group "root"
    mode 0755
    action :create
  end
  
  #cleanup script
  template '/usr/local/bin/cleanup-mysql-backup' do
    source 'cleanup_backup.erb'
    owner 'root'
    group 'root'
    mode '0700'
  end
  
  #backup script
  template '/usr/local/bin/create-mysql-backup' do
    source 'create_backup.erb'
    owner 'root'
    group 'root'
    mode '0700'
  end
  
  #cron script
  cookbook_file '/etc/cron.d/mysql-backup' do
    source 'cron_backup'
    owner 'root'
    group 'root'
    mode '0644'
  end
  
  
end