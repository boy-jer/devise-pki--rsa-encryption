require 'devise'
require 'openssl'
require 'digest/sha2'

require 'devise-pki/model'
require 'devise-pki/schema'
require 'devise-pki/version'

module Devise

  mattr_accessor :pki_key_size
  @@pki_key_size = 1024 

  mattr_accessor :pki_default_cipher
  @@pki_default_cipher="AES-256-OFB"

end

Devise.add_module :pkikeys, :model => 'devise-pki/model'
