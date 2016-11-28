#
# Cookbook Name:: rkhunter
# Recipe:: default
#
# Copyright (C) 2014 Greg Palmier

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#   http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package 'rkhunter' do
  action :install
end

template '/etc/default/rkhunter' do
  source 'rkhunter.erb'
  owner 'root'
  group 0
  mode 00644
end

template '/etc/rkhunter.conf.local' do
  source 'rkhunter.conf.local.erb'
  owner 'root'
  group 0
  mode 00644
end

template '/usr/local/bin/analyze_rkhunter_log' do
  source 'analyze_rkhunter_log.erb'
  owner 'root'
  group 0
  mode 00700
  variables(
    slack_webhook_url: node['rkhunter']['slack_webhook_url']
  )
end

cron 'check rkhunter log' do
  user 'root'
  minute '0'
  hour '14'
  command '/usr/local/bin/analyze_rkhunter_log'
end
