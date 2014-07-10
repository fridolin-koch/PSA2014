#
# Cookbook Name:: base_utils
# Recipe:: default
#
# Copyright 2014, Fridolin Koch
#
# MIT

#we only support debian at this time
if node['platform'] == 'debian'

  #debian sources
  cookbook_file "/etc/apt/sources.list" do
    source "apt_sources.list"
    mode 0644
    owner "root"
    group "root"
  end

  execute "Adding dotdeb GPG-Key" do
    command "cd /root && wget -nc http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg"
    action :run
  end

  execute "update apt sources" do
    command "aptitude update"
    action :run
  end

  #install utils and usefull packages

  #git
  package "git" do
    action :install
  end

  #svn
  package "subversion" do
    action :install
  end

  #htop
  package "htop" do
    action :install
  end

  #ruby - always useful :)
  package "ruby" do
    action :install
  end

  #vim
  package "vim" do
    action :install
  end

  #curl
  package "curl" do
    action :install
  end

  #sudo
  package "sudo" do
    action :install
  end

  #telnet
  package "telnet" do
    action :install
  end

  #xterm
  package "xterm" do
    action :install
  end

  #screen
  package "screen" do
    action :install
  end

  #ntp client
  package "ntp" do
    action :install
  end

  #dig
  package "dnsutils" do
    action :install
  end

  #network debug
  package "tcpdump" do
    action :install
  end

  #lync text-based browser
  package "lynx" do
    action :install
  end

  #nfs client
  package "nfs-common" do
    action :install
  end

  #smb client
  package "cifs-utils" do
    action :install
  end

  package "gnutls-bin" do
    action :install
  end

  #mount home direcotry
  if node['nfs']['mount-home']
    mount "/home" do
      device "192.168.1.7:/fs/home"
      fstype "nfs"
      options "rw,nosuid"
      action [:mount, :enable]
    end
  end

  #ssh server banner
  template "/etc/motd" do
    source "sshd_banner.erb"
    mode 0644
    owner "root"
    group "root"
  end

  #ssh server configuration
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

  #ntp
  cookbook_file "/etc/ntp.conf" do
    source "ntp.conf"
    mode 0644
    owner "root"
    group "root"
  end

  service "ntp" do
    action :restart
  end

  #bashrc
  cookbook_file "/root/.bashrc" do
    source "bashrc"
    mode 0644
    owner "root"
    group "root"
  end

  #set shells
  cookbook_file "/etc/shells" do
    source "etc_shells"
    mode 0644
    owner "root"
    group "root"
  end

  #create ssh directory
  directory "/root/.ssh" do
    owner "root"
    group "root"
    mode 0700
    action :create
  end

  cookbook_file "/root/.ssh/authorized_keys" do
    source "root_authorized_keys"
    mode 0600
    owner "root"
    group "root"
  end

  #create users and groups
  group "psateam" do
    gid 1005
    action :create
  end



  #-----------
  # Networking
  #-----------

  if node['networking']['gateway']

    cookbook_file "/etc/firewall.rules" do
      source "firewall.rules"
      mode 0644
      owner "root"
      group "root"
    end

    #restore firewall rules from file
    execute "Restoring firewall rules" do
      command "/sbin/iptables-restore < /etc/firewall.rules"
      action :run
    end

    #creating iptables master file
    execute "Creating iptables master file" do
      command "/sbin/iptables-save > /etc/iptables.up.rules"
      action :run
    end

    #network pre-up hook
    cookbook_file "/etc/network/if-pre-up.d/iptables" do
      source "if-pre-up.d_iptables"
      mode 0700
      owner "root"
      group "root"
    end

    cookbook_file "/etc/apt/apt.conf.d/70debconf" do
     source "70debconf"
     mode 0644
     owner "root"
     group "root"
    end

    #dhcp client config for eth0

    cookbook_file "/etc/dhcp/dhclient.conf" do
     source "etc_dhcp_dhclient.conf"
     mode 0644
     owner "root"
     group "root"
    end

  end

  #proxy
  cookbook_file "/etc/environment" do
   source "etc_environment"
   mode 0644
   owner "root"
   group "root"
  end

  #sysctl conf
  template "/etc/sysctl.conf" do
     source "etc_sysctl.erb"
     mode 0644
     owner "root"
     group "root"
  end

  #networking configuration
  template "/etc/network/interfaces" do
    source "network_interfaces.erb"
    mode 0644
    owner "root"
    group "root"
  end

  execute "Restart network" do
    command "ifdown eth1 && ifup eth1"
    action :run
  end

  #nfs config
  cookbook_file "/etc/idmapd.conf" do
   source "etc_idmapd.conf"
   mode 0644
   owner "root"
   group "root"
  end

  #nfs restart
  service "nfs-common" do
    action :restart
  end

end
