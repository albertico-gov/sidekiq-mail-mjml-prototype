#!/usr/bin/env ruby

require 'sinatra/base'
require 'sidekiq'
require 'mail'
require 'mjml'
require 'erubis'
require 'dotenv'

# Load environment variables.
Dotenv.load 'sidekiq.env', 'mail.env'

# Load configurations...
require_relative 'config/mail' # Mail
require_relative 'config/mjml' # MJML
require_relative 'config/sidekiq' # Sidekiq

# Load Sidekiq worker for sending emails (EmailWorker)
require_relative 'workers/email'

# Load and run the Sinatra application.
require_relative 'app'
run App
