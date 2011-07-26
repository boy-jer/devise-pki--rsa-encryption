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

          if old_content.match(Regexp.new(/^\s# ==> PKI User class/))
            sub=/####PKI Code Block.*####PKI Code Block/
            gsub_file(devise_initializer_path,sub,"") 
          end
          
          inject_into_file(devise_initializer_path, :before => "  # ==> Configuration for :confirmable\n") do
<<-CONTENT
  ####PKI Code Block
  config.pki_key_size=2048
  config.pki_key_owner_model=:#{class_name.underscore}
  config.pki_priv_key_seed="#{Digest::SHA512.new(OpenSSL::PKey::RSA.generate(4096).to_pem).hexdigest}"
  config.pki_hash_loop=500
  ####PKI Code Block
CONTENT
          end
        end
      end

      hook_for :orm do |resp|
        STDERR.puts resp.inspect
      end
      
      nil
    end
  end
end
