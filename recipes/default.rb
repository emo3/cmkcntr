#
# Cookbook:: cmkpod
# Recipe:: default
#
# Copyright:: 2023, The Authors, All Rights Reserved.

package %w(podman jq)

remote_file "#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_file']}" do
  source "#{node['cmk']['media_url']}/#{node['cmk']['server_file']}"
  mode '0755'
  action :create
  notifies :run, 'execute[load-cmk]', :immediately
end

execute 'load-cmk' do
  command "podman load --input=#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_file']}"
  action :nothing
  notifies :run, 'execute[run-cmk]', :immediately
end

execute 'run-cmk' do
  command "podman container run \
    -e CMK_PASSWORD=\"#{node['cmk']['admin_passwd']}\" \
    -dit \
    -p 8080:5000 \
    -p 8000:8000 \
    -v dvomon:/omd/sites \
    --name dvomon \
    -v /etc/localtime:/etc/localtime:ro \
    --restart always \
    checkmk/check-mk-enterprise:#{node['cmk']['cmk_release']}"
  action :nothing
end

ruby_block 'wait_secret' do
  block do
    iter = 0
    until ::File.exist?(node['cmk']['secret_file']) || iter > 30
      sleep(1)
      iter += 1
      ## uncomment if debugging
      # puts "iter=#{iter}"
    end
    raise 'Timeout waiting for secret' unless iter <= 30
  end
end

template node['cmk']['secret_file'] do
  source 'automation.secret.erb'
  mode '0755'
  variables(
    cmk_secret: node['cmk']['secret']
  )
  # comment if debugging
  sensitive true
  only_if { ::File.exist?(node['cmk']['secret_file']) }
end

## Uncomment if debugging
# ruby_block 'Results' do
#   only_if { ::File.exist?(node['cmk']['secret_file']) }
#   block do
#     print "\n"
#     File.open(node['cmk']['secret_file']).each do |line|
#       print line
#     end
#   end
# end

# List rule - curl
template '/usr/local/bin/listrulec.sh' do
  source 'listrulec.sh.erb'
  mode '0755'
  variables(
    cmkserver: 'localhost',
    cmksite: node['cmk']['site_name'],
    apitoken: node['cmk']['secret']
  )
  sensitive true
  notifies :run, 'execute[test_api]', :immediately
end

# Test to verify the Checkmk API
execute 'test_api' do
  command '/usr/local/bin/listrulec.sh'
  cwd '/usr/local/bin'
  live_stream true
  action :nothing
end
