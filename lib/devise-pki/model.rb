module Devise
  module Models
    # PKIKeys is responsible for providing and maintaining the public and private keys of a user
    module Pkikey
    
      extend ActiveSupport::Concern

      included do
        has_many("#{Devise.pki_key_owner_model}AssetKeys".underscore)
        before_create :create_pkikeys
      end

      def cache_password=(x)
        @password = x
        @password_hash = nil
      end

      def pki_priv_key
        OpenSSL::PKey::RSA.new(self.pki_priv_key_pem, password_hash)
      end
      
      def pki_pub_key
        OpenSSL::PKey::RSA.new(self.pki_pub_key_pem)
      end
            
      def encrypt(plaintext)
        pki_pub_key.public_encrypt(plaintext)
      end

      def decrypt(ciphertext)
        pki_priv_key.private_decrypt(ciphertext)
      end
      
      def signature(plaintext)
        Base64.encode64(pki_priv_key.private_encrypt(Digest::SHA256.digest(plaintext)))
      end
      
      def verify(plaintext,signature)
        pki_pub_key.public_decrypt(Base64.decode64(signature))==Digest::SHA256.digest(plaintext)
      end
      
      def unlocked?
        @password_hash!=nil
      end
      
    protected

      def create_pkikeys
        key = OpenSSL::PKey::RSA.generate(self.class.pki_key_size)
        self.pki_pub_key_pem = key.public_key.to_pem
        self.pki_priv_key_pem = key.to_pem(OpenSSL::Cipher.new("AES-256-OFB"),password_hash)
      end
      
      def password_hash
        @password_hash ||= process_pwd_hash
      end

      def process_pwd_hash 
        raise "User model does not have a cached copy of password" unless @password
        seed = self.class.pki_priv_key_seed
        raise "Devise.setup does not include config.pki_priv_key_seed which is require entrophy" unless seed
        hs = @password + self.authenticatable_salt + seed
        self.class.pki_hash_loop.times { hs = Digest::SHA512.digest(hs) }
        hs
      end
      
      module ClassMethods   
        Devise::Models.config(self, :pki_key_size)
        Devise::Models.config(self, :pki_priv_key_seed)
        Devise::Models.config(self, :pki_hash_loop)
      end
    end   
  end
end
