module Devise
  module PKI
    module Mongoid
      def attr_encrypted(col,options={})
        keystore = "#{Devise.pki_key_owner_model}_asset_keys".to_sym
        has_many keystore, as: :pki_encryptable
        
        #FIXME: This should check that options[:type] is encryptable/serializable
        field "encrypted_#{col}"
        
        class_eval <<-RUBY,__FILE__,__LINE__+1       
          def #{col}=(x)
            encrypted_#{col}=#{keystore}.encrypt(x)
          end
          
          def #{col}
            #{keystore}.decrypt(x)
          end
        RUBY
        if 0
          #FIXME: Run once / syntax is also wrong 
          def user=(x)
            #{keystore.camelize}.new(:user=>x,:pki_encryptable=>self)         
          end 
        end
      end
    end
  end
end

Mongoid::Document::ClassMethods.send(:include, Devise::PKI::Mongoid)
