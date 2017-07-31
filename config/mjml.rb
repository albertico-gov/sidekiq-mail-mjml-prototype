# config/mjml.rb

MJML.configure do |config|
  # Make sure that MJML is installed and that the proper binary path is configured.
  # Could not make the following config work: 
  # config.bin_path = '/usr/bin/env mjml'
  config.bin_path = '/usr/local/bin/mjml'
  # config.logger = MJML::Logger.setup!(STDOUT)
  config.minify_output = true
  # Set the validation level to :strict if you want to have MJML v3.0 validation.
  config.validation_level = :strict # :skip/:soft/:strict
end
