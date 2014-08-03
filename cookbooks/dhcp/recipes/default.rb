#
# Cookbook Name:: dhcp
# Recipe:: default
#
# (c) 2014 Fridolin Koch & Mattias Lang
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

#install dhcp server
  package "isc-dhcp-server" do
    action :install
  end

#networking configuration
  template "/etc/dhcp/dhcpd.conf" do
    source "dhcp_conf.erb"
    mode 0644
    owner "root"
    group "root"
  end

execute "Start DHCP" do
    command "/etc/init.d/isc-dhcp-server restart"
    action :run
  end
