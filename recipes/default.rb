#
# Cookbook:: cmkpod
# Recipe:: default
#
# Copyright:: 2023, The Authors, All Rights Reserved.

package 'podman'

remote_file "#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_file']}" do
  source "#{node['cmk']['server_file']}/#{node['cmk']['media_url']}"
  mode '0755'
  action :create
end

execute 'load-podman' do
  command "podman load --input=#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_file']}"
  action :nothing
end
