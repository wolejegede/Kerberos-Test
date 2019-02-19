name             'krb5'
maintainer       'Wole Jegede'
maintainer_email 'wolejegede@gmail.com'
license          'Apache-2.0'
description      'Installs and configures Kerberos V authentication'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.5.0'

%w(redhat centos7-x86_64).each do |os|
  supports os
end

depends 'build-essential'
depends 'ntp'

source_url 'https://github.com/atomic-penguin/cookbook-krb5' if
  respond_to?(:source_url)
issues_url 'https://github.com/atomic-penguin/cookbook-krb5/issues' if
  respond_to?(:issues_url)
chef_version '>= 14.5.33' if
  respond_to?(:chef_version)
