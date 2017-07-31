# sidekiq_server.rb

# Make sure you that Redis is installed and running.
# Then start sidekiq with:
# sidekiq -r ./sidekiq_server.rb

require 'sidekiq'
require 'mail'
require 'mjml'
require 'erubis'
require 'dotenv'

# Load environment variables.
Dotenv.load 'sidekiq.env', 'mail.env'

# Load configurations...
require_relative 'config/sidekiq' # Sidekiq
require_relative 'config/mail' # Mail
require_relative 'config/mjml' # MJML

# Load Sidekiq worker for sending emails (EmailWorker)
require_relative 'workers/email'
