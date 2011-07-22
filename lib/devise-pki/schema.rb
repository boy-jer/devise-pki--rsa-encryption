module DevisePKI
  module Schema
    def pkikeys
      apply_devise_schema :pki_pub_key,Text
      apply_devise_schema :pki_priv_key_enc,Text
    end
  end
end

Devise::Schema.send :include, DevisePKI::Schema