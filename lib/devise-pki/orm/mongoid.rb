module Devise
  module PKI
    module Mongoid
      def attr_encrypted(col,options={})
      
        has_many (Devise.pki_user_class
        
        field "encrypted_#{col}"
        class_eval <<-RUBY,__FILE__,__LINE__+1
          
          
          def #{col}=(x)
          end
          
          def #{col}
          end
          
          def user_key(user)
            user
          end
        RUBY
      end
    end
  end
end

Mongoid::Document::ClassMethods.send(:include, Devise::PKI::Mongoid)
