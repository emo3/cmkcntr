default['cmk']['cmk_release'] = '2.1.0p26'
default['cmk']['media_url'] = 'http://10.1.1.30/media'
default['cmk']['el_version'] =
  if node['platform_version'] < '8'
    '7'
  else
    '8'
  end
default['cmk']['server_file'] = "check-mk-enterprise-docker-#{node['cmk']['cmk_release']}.tar.gz"
default['cmk']['site_name'] = 'cmk'
default['cmk']['server_name'] = 'checkmks'
default['cmk']['admin_passwd'] = 'cmkadmin'
default['cmk']['secret'] = '390facd5-4d84-4f6b-8df6-c647ef1e9dde'
