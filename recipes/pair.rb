#
# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: drbd
# Recipe:: pair
#
# Copyright 2011, Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/shell_out'

include_recipe "drbd"

if node.key? :drbd and node[:drbd].key? :resources then
    node[:drbd][:resources].each do |name, data|
        drbd_pair name do
            action [:create, :bootstrap]

            disk data[:disk]
            remote_host data[:remote_host]

            device data[:device] if data.key? :device
            master data[:master] if data.key? :master

            local_ip data[:local_ip] if data.key? :local_ip
            local_port data[:local_port] if data.key? :local_port

            remote_ip data[:remote_ip] if data.key? :remote_ip
            remote_port data[:remote_port] if data.key? :remote_port
        end
    end
end
