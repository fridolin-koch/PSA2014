#
# Cookbook Name:: base_utils
# Attributes:: default
#
# Copyright 2013, Airmotion GmbH News and Entertainment
#
# All rights reserved - Do Not Redistribute
#
#dns related
default['dns']['ttl'] = 300
default['dns']['zone'] = "airmotion.de"
default['dns']['aliases'] = []
#exim4
default['exim4']['dc_readhost'] = 'airmotion.de'
default['exim4']['dc_smarthost'] = '62.245.179.42'
default['exim4']['dc_relay_nets'] = '10.0.0.0/24'
