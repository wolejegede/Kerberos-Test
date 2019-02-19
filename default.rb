# 
# Cookbook Name:: krb5
# Attribute:: default
#


case node['platform_family']
when 'rhel'
  default['krb5']['packages'] = %w(krb5-libs krb5-workstation pam pam_krb5 authconfig)
  default['krb5']['authconfig'] = 'authconfig --enableshadow --enablemd5 --enablekrb5 --enablelocauthorize --update'
  default['krb5']['conf_dir'] = '/etc/krb5kdc'
  default['krb5']['data_dir'] = '/var/kerberos/krb5kdc'
  default['krb5']['kadmin']['service_name'] = 'kadmin'
  default['krb5']['kadmin']['packages'] = %w(krb5-server)
  default['krb5']['kdc']['service_name'] = 'krb5kdc'
  default['krb5']['kdc']['packages'] = %w(krb5-server krb5-server-ldap)
  default['krb5']['kprop']['service_name'] = 'kprop'
  default['krb5']['devel']['packages'] = %w(krb5-devel)
end


default_realm =
  if node['krb5'].key?('krb5_conf') && node['krb5']['krb5_conf'].key?('libdefaults') &&
     node['krb5']['krb5_conf']['libdefaults'].key?('default_realm')
    node['krb5']['krb5_conf']['libdefaults']['default_realm']
  elsif node['domain']
    node['domain'].upcase
  else
    'LOCAL'
  end

# Default location for keytabs generated from LWRP
default['krb5']['keytabs_dir'] = '/etc/security/keytabs'

# Default principals
default['krb5']['default_principals'] = ["host/#{node['fqdn']}"]

# Install build-essential at compile time
override['build-essential']['compile_time'] = true

# Include ntp recipe?
default['krb5']['include_ntp'] = true

# Client Packages
default['krb5']['client']['packages'] = node['krb5']['packages']
default['krb5']['client']['authconfig'] = node['krb5']['authconfig']

# logging
default['krb5']['krb5_conf']['logging']['default'] = 'FILE:/var/log/krb5libs.log'
default['krb5']['krb5_conf']['logging']['kdc'] = 'FILE:/var/log/krb5kdc.log'
default['krb5']['krb5_conf']['logging']['admin_server'] = 'FILE:/var/log/kadmind.log'

# libdefaults
default['krb5']['krb5_conf']['libdefaults']['default_realm'] = default_realm
default['krb5']['krb5_conf']['libdefaults']['dns_lookup_realm'] = false
default['krb5']['krb5_conf']['libdefaults']['dns_lookup_kdc'] = true
default['krb5']['krb5_conf']['libdefaults']['forwardable'] = true
default['krb5']['krb5_conf']['libdefaults']['renew_lifetime'] = '24h'
default['krb5']['krb5_conf']['libdefaults']['ticket_lifetime'] = '24h'

# realms
default['krb5']['krb5_conf']['realms']['default_realm'] = default_realm
default['krb5']['krb5_conf']['realms']['default_realm_kdcs'] = [node['fqdn']]
default['krb5']['krb5_conf']['realms']['default_realm_admin_server'] = node['fqdn']
# This syntax is deprecated, but will still work for defining realms w/ 1:1 mapping to DNS
# default['krb5']['krb5_conf']['realms']['realms'] = [default_realm]
# This attribute can be a single value or a list
default['krb5']['krb5_conf']['realms']['realms'][default_realm] = node['domain']

# includedir
default['krb5']['krb5_conf']['includedir'] = []

# appdefaults
default['krb5']['krb5_conf']['appdefaults']['pam']['debug'] = false
default['krb5']['krb5_conf']['appdefaults']['pam']['forwardable'] = node['krb5']['krb5_conf']['libdefaults']['forwardable']
default['krb5']['krb5_conf']['appdefaults']['pam']['renew_lifetime'] = node['krb5']['krb5_conf']['libdefaults']['renew_lifetime']
default['krb5']['krb5_conf']['appdefaults']['pam']['ticket_lifetime'] = node['krb5']['krb5_conf']['libdefaults']['ticket_lifetime']
default['krb5']['krb5_conf']['appdefaults']['pam']['krb4_convert'] = false
