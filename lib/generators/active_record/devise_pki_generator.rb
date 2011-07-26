require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class DeviseInvitableGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_devise_migration
        migration_template "migration.rb", "db/migrate/devise_pki_add_to_#{table_name}"
      end
      
      def copy_user_asset_key_model
        path = File.join("app","models", "#{file_path}_asset_key.rb")
        template "asset_key.rb", path
      end
    end
  end
end
