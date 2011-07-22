module DevisePki
  module Generators
    class DevisePkiGenerator < Rails::Generators::NamedBase
      namespace "devise_pki"

      desc "Add :pkikey directive in the given model and register the model as the owner of DigitalRightsKeys."

      def inject_devise_invitable_content
        path = File.join("app", "models", "#{file_path}.rb")
        inject_into_file(path, "pkikey, :", :after => "devise :") if File.exists?(path)
      end

      def add_config_options_to_initializer
        devise_initializer_path = "config/initializers/devise.rb"
        if File.exist?(devise_initializer_path)
          old_content = File.read(devise_initializer_path)
          
          if old_content.match(Regexp.new(/^\s# ==> Configuration for PKI key schema\n/))
            false
          else
            inject_into_file(devise_initializer_path, 
               :before => "  # ==> Configuration for :confirmable\n") do
<<-CONTENT
  # ==> Configuration for PKI key schema
  config.pki_key_owner_model=#{file_path.to_sym}
  
CONTENT
            end
          end
        end
      end
    end
  end
end