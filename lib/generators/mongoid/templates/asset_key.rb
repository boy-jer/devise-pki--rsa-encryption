class <%= class_name %>AssetKey
  include Mongoid::Document

  #FIXME: This needs to get pushed into a orm independent mixin
  
  field :block_key
  field :block_iv
  field :block_cipher
  
  belongs_to :pki_encryptable, polymorphic: true
  belongs_to :<%= class_name.underscore %>
  
  before_create :handle_user_list
  before_validation :build_random_encryption_key
  before_save :encrypt_key
  
  def <%= class_name.pluralize.underscore %>=(x)
    @<%= class_name.underscore %>_list = x
  end
  
  def cache_<%= class_name.underscore %>=(<%= class_name.underscore %>)
    @cache_<%= class_name.underscore %>=<%= class_name.underscore %>
  end
  
  <%- %w{en de}.each do |pre| -%>
  def <%= pre %>crypt(data)
    c = cipher(:<%= pre %>crypt)
    c.update(data)+c.final 
  end
    
  <%- end -%>  
  private 
  
  def cipher(mode)
    cipher = OpenSSL::Cipher.new(self.block_cipher).send(mode)
    cipher.key= @cache_<%= class_name.underscore %>.decrypt(Base64.decode64(self.block_key)) 
    cipher.iv= @cache_<%= class_name.underscore %>.decrypt(Base64.decode64(self.block_iv))
  end
  
  def build_random_encryption_key
    unless self.block_key
      self.block_cipher||="AES-256-CBC"
      cipher = OpenSSL::Cipher.new(self.block_cipher).encrypt
      self.block_key = cipher.random_key
      self.block_iv = cipher.random_iv
    end
  end
  
  def handle_user_list
    if @user_list
      self.user = @user_list.shift
      @<%= class_name.underscore %>_list.each do |<%= class_name.underscore %>|
        <%= class_name %>AssetKey.create(:<%=class_name.underscore %>=><%= class_name.underscore %>, :pki_encryptable=>self.pki_encryptable,
            :block_key=>self.block_key,:block_iv=>self.block_iv,:block_cipher=>self.block_cipher)
      end     
    end
  end

  def encrypt_key
    self.block_key = Base64.encode64(self.user.encrypt(self.block_key))    
    self.block_iv = Base64.encode64(self.user.encrypt(self.block_iv))
  end
end
