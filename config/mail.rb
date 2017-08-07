# config/mail.rb

# Making sure that Mail is thread safe for Sidekiq.
# See: https://github.com/mperham/sidekiq/wiki/Problems-and-Troubleshooting#use-only-thread-safe-libraries
# Additional details:
# - https://github.com/mperham/sidekiq/issues/3295
# - https://github.com/mikel/mail/issues/912
Mail.eager_autoload!

Mail.defaults do
  # These settings have been tested with AWS SES.
  # Settings may need to be tweaked for Gmail, AWS WorkMail, and other services.
  smtp_settings = { :address   => ENV['MAIL_SMTP_SERVER'],
                    :port      => ENV['MAIL_SMTP_PORT'],
                    :user_name => ENV['MAIL_SMTP_USERNAME'],
                    :password  => ENV['MAIL_SMTP_PASSWORD'],
                    :authentication => 'plain',
                    :enable_starttls_auto => true }
  delivery_method :smtp, smtp_settings
end
