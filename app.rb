# app.rb

# Execute the following command to start the Sinatra application:
# rackup config.ru

class App < Sinatra::Base
  set :erb, :escape_html => true

  get '/' do
    erb :index
  end

  post '/send' do
    # Validate that required parameters have been sent.
    halt 400 unless params[:rcpt] && params[:subj] && params[:msg]

    # Get parameters.
    @rcpt = params[:rcpt]
    @subj = params[:subj]
    @msg = params[:msg]
    # Enqueue Sidekiq worker.
    EmailWorker.perform_async(@rcpt, @subj, @msg)

    erb :send
  end
end
