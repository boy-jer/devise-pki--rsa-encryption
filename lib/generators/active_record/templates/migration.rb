class DevisePkiAddTo<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    change_table :<%= table_name %> do |t|
      t.string     :pki_pub_key_pem
      t.string     :pki_priv_key_pem
    end
    
    create_table :<%= class_name.underscore %>_asset_keys do |t|
      t.string   :encryption_key
      t.integer  :<%= class_name.underscore>_id
      t.integer  :pki_encryptable_id
      t.string   :pki_encryptable_type
    end
  end
  
  def self.down
    change_table :<%= table_name %> do |t|
      t.remove :pki_pub_key_pem, :pki_priv_key_pem
    end
    
    drop_table :<%= class_name.underscore %>_asset_keys 
  end
end
