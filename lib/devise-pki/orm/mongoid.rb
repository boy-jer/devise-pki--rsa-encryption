module Mongoid
  module Encryptable
    extend ActiveSupport::Concern

    keymodel="user"
    
    included do
      keystore = "#{keymodel}_asset_keys".to_sym
      has_many(keystore, :as=>:pki_encryptable)
      before_save :encrypt_fields
    end
        
    class_eval <<-RUBY,__FILE__,__LINE__+1
      def cache_#{keymodel}=(x)
        @asset_key=self.#{keymodel}_asset_keys.where(:#{keymodel}=>x).first
        @asset_key.cache_#{keymodel}=x
      end 
    
      def #{keymodel.pluralize}=(*user_list)
        @user_list=[user_list].flatten
      end
    
      def share(from_user,to_user)
        if valid_key = self.user_asset_keys.where(:#{keymodel}=>from_user).first
          valid_key.cache_user=from_user
          valid_key.copy_to_user(to_user)
        else
          nil
        end
      end

      def encrypt_fields
        if new_record?
          ring = #{keymodel.camelize}AssetKey.build_keyring(keymodel.pluralize.to_sym=>@user_list, :pki_encryptable=>self)
          ring.each { |key| key.save }
          @asset_key = ring.first
        end
        @@encrypted_fields.each do |label|
          ct = @asset_key.encrypt(self.send(label))
          write_attribute("encrypted_\#{label}",Base64.encode64(ct)) 
        end
      end
    RUBY
    
    private
    
    def decrypt_attribute(label)  
      @asset_key.decrypt(Base64.decode64(read_attribute(label)))
    end    
 
    module ClassMethods
      def attr_encrypted(model)
        field("encrypted_#{model}")
        @@encrypted_fields||=[]
        @@encrypted_fields << model
        class_eval <<-RUBY,__FILE__,__LINE__+1
          def #{model}=(x)
            @#{model} = x
          end
        
          def #{model}
            @#{model} ||= decrypt_attribute(#{model}) 
          end
        RUBY
      end    
    end
  end
end