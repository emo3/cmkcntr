default['cmk']['cmk_release'] = '2.1.0p26'
default['cmk']['media_url'] = 'http://10.1.1.30/media'
default['cmk']['server_file'] = "check-mk-enterprise-docker-#{node['cmk']['cmk_release']}.tar.gz"
default['cmk']['site_name'] = 'cmk'
default['cmk']['server_name'] = 'checkmks'
# container’s web server listens on port
default['cmk']['listen_port'] = '8080'
# port for the Agent Receiver in order to be able to register the agent controller
default['cmk']['register_port'] = '8000'
default['cmk']['admin_passwd'] = 'cmkadmin'
default['cmk']['secret'] = '390facd5-4d84-4f6b-8df6-c647ef1e9dde'
default['cmk']['secret_file'] = '/var/lib/containers/storage/volumes/dvomon/_data/cmk/var/check_mk/web/automation/automation.secret'
