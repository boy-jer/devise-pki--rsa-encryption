
class <%= class_name %>AssetKey < ActiveRecord::Base
  belongs_to :pki_encryptable, polymorphic: true
  belongs_to :<%= class_name.underscore %>
end
