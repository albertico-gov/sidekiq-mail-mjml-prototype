# config/mail.rb

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
