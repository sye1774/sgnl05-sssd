# == Class: sssd
#
# Configures and installs SSSD
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Examples
#
# class {'::sssd':
#   config => {
#     'sssd' => {
#       'domains'             => 'ad.example.com',
#       'config_file_version' => 2,
#       'services'            => ['nss', 'pam'],
#     }
#     'domain/ad.example.com' => {
#       'ad_domain'                      => 'ad.example.com',
#       'ad_server'                      => ['server01.ad.example.com', 'server02.ad.example.com'],
#       'krb5_realm'                     => 'AD.EXAMPLE.COM',
#       'realmd_tags'                    => 'joined-with-samba',
#       'cache_credentials'              => true,
#       'id_provider'                    => 'ad',
#       'krb5_store_password_if_offline' => true,
#       'default_shell'                  => '/bin/bash',
#       'ldap_id_mapping'                => false,
#       'use_fully_qualified_names'      => false,
#       'fallback_homedir'               => '/home/%d/%u',
#       'access_provider'                => 'simple',
#       'simple_allow_groups'            => ['admins', 'users'],
#     }
#   }
# }
#
# === Authors
#
# Gjermund Jensvoll <gjerjens@gmail.com>
#
# === Copyright
#
# Copyright 2015 Gjermund Jensvoll
#
class sssd (
  $ensure                = $sssd::params::ensure,
  $config                = $sssd::params::config,
  $sssd_package          = $sssd::params::sssd_package,
  $sssd_service          = $sssd::params::sssd_service,
  $extra_packages        = $sssd::params::extra_packages,
  $config_file           = $sssd::params::config_file,
  $mkhomedir             = $sssd::params::mkhomedir,
  $enable_mkhomedir_cmd  = $sssd::params::enable_mkhomedir_cmd,
  $disable_mkhomedir_cmd = $sssd::params::disable_mkhomedir_cmd,
  $pam_mkhomedir_check   = $sssd::params::pam_mkhomedir_check,
) inherits sssd::params {

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")

  validate_string(
    $sssd_package,
    $sssd_service,
    $enable_mkhomedir_cmd,
    $disable_mkhomedir_cmd,
    $pam_mkhomedir_check
  )

  validate_array(
    $extra_packages
  )

  validate_bool(
    $mkhomedir
  )

  validate_hash(
    $config
  )

  class { '::sssd::install':
    ensure         => $ensure,
    sssd_package   => $sssd_package,
    extra_packages => $extra_packages,
  }

  class { '::sssd::config':
    ensure       => $ensure,
    config       => $config,
    sssd_package => $sssd_package,
    config_file  => $config_file,
    mkhomedir    => $mkhomedir,
  }

  class { '::sssd::service':
    sssd_service => $sssd_service,
    mkhomedir    => $mkhomedir,
  }

}