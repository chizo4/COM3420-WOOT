# frozen_string_literal: true

source = ERB.new(File.read("#{Rails.root}/config/ldap.yml")).result
ldap_config = if defined?(Psych::VERSION) && Psych::VERSION > '4.0'
                YAML.unsafe_load(source)[Rails.env]
              else
                YAML.load(source)[Rails.env]
              end

SheffieldLdapLookup::LdapFinder.ldap_config = ldap_config
::Devise.ldap_config = -> { ldap_config }
