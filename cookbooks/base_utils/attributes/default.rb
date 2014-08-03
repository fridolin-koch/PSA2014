#
# Cookbook Name:: base_utils
# Attributes:: default
#
# (c) 2014 Fridolin Koch & Mattias Lang
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#

#networking stuff
default['networking']['eth1']['address'] = nil
default['networking']['eth1']['gateway'] = '192.168.1.1'
default['networking']['eth1']['netmask'] = '255.255.255.0'

#gatway stuff
default['networking']['gateway'] = false

default['networking']['eth1:0']['address'] = nil
default['networking']['eth1:0']['netmask'] = '255.255.255.0'

default['networking']['eth1:1']['address'] = nil
default['networking']['eth1:1']['netmask'] = '255.255.255.0'

#shares
default['nfs']['mount-home'] = true
