#
# Cookbook Name:: base_utils
# Recipe:: default
#
# Copyright 2013, Airmotion GmbH News and Entertainment
#
# All rights reserved - Do Not Redistribute
#
if node['platform'] == 'debian'
  include_recipe "apt"
  # add dotdeb and php php55
  apt_repository "dotdeb-php55" do
    uri "http://packages.dotdeb.org"
    distribution "wheezy-php55"
    components ['all']
    key "http://www.dotdeb.org/dotdeb.gpg"
    action :add
  end
  apt_repository "dotdeb" do
    uri "http://packages.dotdeb.org"
    distribution "wheezy"
    components ['all']
    key "http://www.dotdeb.org/dotdeb.gpg"
    action :add
  end
  
  #debian sources
  cookbook_file "/etc/apt/sources.list" do
    source "apt_sources.list"
    mode 0644
    owner "root"
    group "root"
  end
  
  execute "update apt sources" do
    command "aptitude update"
    action :run
  end
  #install utils
  #git
  apt_package "git" do
    action :install
  end
  #svn
  apt_package "subversion" do
    action :install
  end
  #htop
  apt_package "htop" do
    action :install
  end
  #ruby
  apt_package "ruby" do
    action :install
  end
  #python-pip
  apt_package "python-pip" do
    action :install
  end
  #vim
  apt_package "vim" do
    action :install
  end
  #curl
  apt_package "curl" do
    action :install
  end
  #sudo
  apt_package "sudo" do
    action :install
  end
  #telnet
  apt_package "telnet" do
    action :install
  end
  #supervisor
  apt_package "supervisor" do
    action :install
  end
  #s3cmd
  apt_package "s3cmd" do
    action :install
  end
  #xterm
  apt_package "xterm" do
    action :install
  end
  #screen
  apt_package "screen" do
    action :install
  end
  #ntp
  apt_package "ntp" do
    action :install
  end
  
  if tagged?("exim4-smarthost")
    apt_package "exim4" do
      action :install
    end
    
    template "/etc/exim4/update-exim4.conf.conf" do
      source "exim4-config.erb"
      mode 0600
      owner "root"
      group "root"
    end
    
  end
  #install cli53
  execute "Install utilites " do
    command "pip install cli53"
    action :run
  end

  #get credentials databag
  credentials = data_bag_item('credentials', 'aws')

  if credentials["route53"]
      
    log "Used credentials data bag entry for aws credentials" do
      level :info
    end
      
    #create cli53 config file
    template "/etc/boto.cfg" do
      source "boto-config.erb"
      mode 0600
      owner "root"
      group "root"
      variables({
         :aws_access_key_id => credentials["route53"]["access_key_id"],
         :aws_secret_access_key => credentials["route53"]["secret_access_key"]
      })
    end

  else
  
  log "Could not find credentials data bag, thats bad." do
     level :error
   end
  
  end

  #create update script only on aws node
  if tagged?("aws")
  
    #install metadata tool
    execute "Install ec2-metadata" do
      cwd "/usr/bin"
      command "wget -O ec2metadata http://s3.amazonaws.com/ec2metadata/ec2-metadata && chmod u+x ec2metadata"
      creates "/usr/bin/ec2metadata"
    end
  
    #install our update script
    template "/usr/local/bin/update-route53-dns" do
      source "update-route53-dns.erb"
      mode 0775
      owner "root"
      group "root"
    end
  
    #add script hook for updating ip
    execute "Add if-up hook" do
      cwd "/etc/network/if-up.d"
      command "ln -s /usr/local/bin/update-route53-dns"
      creates "/etc/network/if-up.d/update-route53-dns"
      action :run
    end
  
    #and now lets execute the script
    execute "Updating dns entry" do
      command "/usr/local/bin/update-route53-dns"
      action :run
    end
    
    #install aws command line interface
    execute "Install AWS Command Line Interface " do
      command "pip install awscli --upgrade"
      action :run
    end
    
  
  end
  
  #dns update
  node['dns']['aliases'].each do |_alias|
    
    execute "Adding cname "+_alias do
      command 'cli53 rrcreate %s %s "CNAME" %s --ttl %d --replace' % [node['dns']['zone'], _alias, node[:fqdn], node['dns']['ttl']]
    end
    
  end

  #ssh server config
  template "/etc/motd" do
    source "sshd_banner.erb"
    mode 0644
    owner "root"
    group "root"
  end

  cookbook_file "/etc/ssh/sshd_config" do
    source "sshd_config"
    mode 0644
    owner "root"
    group "root"
  end

  #restart ssh
    service "ssh" do
    action :restart
  end

  #bashrc
  cookbook_file "/root/.bashrc" do
    source "bashrc"
    mode 0644
    owner "root"
    group "root"
  end       

  #create user for deployment
  user "deployment" do
    home "/home/deployment"
    gid "users"
    supports :manage_home => true
    shell "/bin/bash"
    action :create
  end
  
  cookbook_file "/home/deployment/.bashrc" do
    source "bashrc"
    mode 0644
    owner "deployment"
    group "users"
  end    
  
  group "www-data" do
    action :modify
    members "deployment"
    append true
  end
  
  group "users" do
    action :modify
    members "www-data"
    append true
  end
  
  #
  cookbook_file "/etc/sudoers.d/99_deployment" do
    source "sudoers.d_99_deployment"
    mode 0440
    owner "root"
    group "root"
  end 
  
  #create .ssh dir for user
  directory "/home/deployment/.ssh" do
    owner "deployment"
    group "users"
    mode 0700
  end

  #authorized_keys
  cookbook_file "/home/deployment/.ssh/authorized_keys" do
    source "deployment_authorized_keys"
    mode 0600
    owner "deployment"
    group "users"
  end 

  #get credentials databag
  users = data_bag_item('credentials', 'users')

  if users["deployment"]

    #create id_rsa.pub
    file "/home/deployment/.ssh/id_rsa.pub" do
      content users["deployment"]["public_key"]
      mode 0644
      owner "deployment"
      group "users"
    end 
    #create id_rsa
    file "/home/deployment/.ssh/id_rsa" do
      content users["deployment"]["private_key"]
      mode 0600
      owner "deployment"
      group "users"
    end 
  else
    log "Unable to locate credentials for user deployment" do
      level :error
    end
  end
  
  #set shells
  cookbook_file "/etc/shells" do
    source "etc_shells"
    mode 0644
    owner "root"
    group "root"
  end 
  
end
