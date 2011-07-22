module Devise
  module Models
    # PKIKeys is responsible for providing and maintaining the public and private keys of a user
      module Pkikeys
    
      extend ActiveSupport::Concern

      included do
#        include ::DeviseInvitable::Inviter
        before_create :create_pkikeys
      end

      def cache_password=(x)
        @password = x
      end

      def pki_priv_key
        pass_cipher(:dec,Base64.decode64(self.pki_priv_key_enc))
      end
            
      protected

      def create_pkikeys
        key = OpenSSL::PKey::RSA.generate(self.class.pki_key_size)
        #pubkey is plaintext
        self.pki_pub_key = key.public_key.to_pem
        #Keep key string friendly
        self.pki_priv_key_enc = Base64.encode64(pass_cipher(:enc,key.to_pem))
      end
      
      def pass_cipher(mode, msg)
        ch = OpenSSL::Cipher.new(self.class.pki_default_cipher)
        ch.key = password_hash(ch.block_size)
        ch = mode=:enc ? ch.encrypt , ch.decrypt
        ch.update(msg)+ch.finalize
      end     
      
      def password_hash(blocksize)
        raise "User model does not have a cached copy of password" unless @password
        
        #FIXME: This should include the RAILS secret to prevent brute force
        hs = @password # + rails key
        #by default max key size is set by AES-256-OFB so if it has been set higher use better hash
        if blocksize>256
          Digest::SHA512.new(hs)
        else
          Digest::SHA256.new(hs)
        end
      end
      
      module ClassMethods
        Devise::Models.config(self, :pkikeys)
        Devise::Models.config(self, :pki_default_cipher)
        Devise::Models.config(self, :pki_key_size)
      end
    end
  end
end
