# Sidekiq Mail MJML Prototype

Barebones prototype for sending MJML/ERB emails using Sidekiq via a simple Sinatra API.

## Requirements

* Redis must be installed and running.
* Node.js and MJML must be installed.
* Obviously, Ruby must be installed.  ;)
* An SMTP server or service available for sending email messages.

## Prototype Configuration

There are a few parameters that need to be configured for the prototype to work.

### Sidekiq / Redis

Add and edit a `sidekiq.env` file with the Redis host, port and db.

```
export REDIS_HOST=localhost
export REDIS_PORT=6379
export REDIS_DB=YOUR_REDIS_DB
```

Additional Sidekiq configuration changes can be made to the `config/sidekiq.rb` file:

```ruby
# config/sidekiq.rb

Sidekiq.configure_server do |config|
  config.redis = { :host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT'], :db => ENV['REDIS_DB'] }
end

Sidekiq.configure_client do |config|
  config.redis = { :host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT'], :db => ENV['REDIS_DB'] }
end
```

### MJML

Once Node.js is installed, you can install MJML:

```sh
> npm install -g mjml
```

Edit the `config/mjml.rb` file with the MJML binary path, the validation level and any other available parameter.

```ruby
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
```

### Mail / SMTP

The prototype has been tested using Amazon Simple Email Service (SES).  The `mail.env` and `config/mail.rb` can be modified/tweaked for other email services.

Add and edit a `mail.env` file with the SMTP server, port, username, password and sender email:

```
export MAIL_SMTP_SERVER=your.smtp.server.com
export MAIL_SMTP_PORT=587
export MAIL_SMTP_USERNAME=YOUR_IAM_SMTP_USER_FOR_SES
export MAIL_SMTP_PASSWORD=YOUR_VERY_LONG_PASSWORD
export MAIL_MESSAGE_SENDER=user@domain.com
```

Additional Mail configuration changes can be made to the `config/mail.rb` file:

```ruby
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
```

## Running the Prototype

1. Run `bundle install` to get all the gems needed by the prototype.

2.  Make sure that Redis is running.  Redis can be started by running:

```sh
> redis-server
```

3.  Start Sidekiq by running:

```sh
> sidekiq -r ./sidekiq_server.rb
```

4.  Start the Sinatra application by running:

```sh
> rackup config.ru
```

5.  Assuming that Sinatra is listening on `http://localhost:9292/`, make a `POST` request to the `/send` resource with the following parameters:

    * **rcpt** - The email message recipient.
    * **subj** - The email message subject.
    * **msg**  - The email message content.

    [Postman](https://www.getpostman.com/) is your friend!  You can make a `POST` request and send the data via _parameters_ or _form-data_.

