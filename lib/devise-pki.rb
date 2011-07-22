require 'devise'
require 'openssl'
require 'digest/sha2'

require 'devise-pki/model'
require 'devise-pki/schema'
require 'devise-pki/version'

module Devise

  mattr_accessor :pki_key_owner_model
  @@pki_key_owner_model = nil
  
  mattr_accessor :pki_key_size
  @@pki_key_size = 1024 

  mattr_accessor :pki_default_cipher
  @@pki_default_cipher="AES-256-OFB"

# FIXME: Need to work out the work flow for user encrypted fields.
#  class Railtie < Rails::Railtie
#    initializer "devise.active_record" do
#      ActiveSupport.on_load :active_record do
#        require 'devise-pki/orm/activerecord'
#      end
#    end
#  end
end

Devise.add_module :pkikey, :model => 'devise-pki/model'

#require 'devise-pki/orm/mongoid' if defined?(Mongoid)

   