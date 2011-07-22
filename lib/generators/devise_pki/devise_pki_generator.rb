module DevisePki
  module Generators
    class DevisePkiGenerator < Rails::Generators::NamedBase
      namespace "devise_pki"

      desc "Add :pkikey directive in the given model and register the model as the owner of DigitalRightsKeys."

      def inject_devise_pki_
        path = File.join("app", "models", "#{file_path}.rb")
        inject_into_file(path, "pkikey, :", :after => "devise :") if File.exists?(path)
      end
      
      def add_config_options_to_initializer
        devise_initializer_path = "config/initializers/devise.rb"
        if File.exist?(devise_initializer_path)
          old_content = File.read(devise_initializer_path)

          if old_content.match(Regexp.new(/^\s# ==> User class\n/))
            false
          else
            inject_into_file(devise_initializer_path, :before => "  # ==> Configuration for :confirmable\n") do
<<-CONTENT
  # ==> User class
  config.pki_key_owner_class=:#{class_name.underscore}
CONTENT
            end
          end
        end
      end
 
      def copy_user_asset_key_model
        path = File.join("app","models", "#{file_path}_asset_key.rb")
        template config.generators.orm.to_s+".rb", path
      end
    end
  end
end
