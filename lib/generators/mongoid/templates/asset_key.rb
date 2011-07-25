class <%= class_name %>AssetKey
  include Mongoid::Document
  
  field :encryption_key

  belongs_to :pki_encryptable, polymorphic: true
  belongs_to :<%= class_name.underscore %>
end
