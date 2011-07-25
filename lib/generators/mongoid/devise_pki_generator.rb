require 'generators/devise/orm_helpers'

module Mongoid
  module Generators
    class DevisePkiGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)
     
      def copy_user_asset_key_model
        path = File.join("app","models", "#{file_path}_asset_key.rb")
        template "asset_key.rb", path
      end
    end
  end
end