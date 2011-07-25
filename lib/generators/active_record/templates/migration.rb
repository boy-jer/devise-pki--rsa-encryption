class DevisePkiAddTo<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    change_table :<%= table_name %> do |t|
      t.string     :pki_pub_key
      t.string     :pki_priv_key_enc
    end
  end
  
  def self.down
    change_table :<%= table_name %> do |t|
      t.remove :pki_pub_key, :pki_priv_key_enc
    end
  end
end
