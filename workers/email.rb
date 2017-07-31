# workers/email.rb

# This worker does the following:
#   - Uses the MJML gem to handle the MJML template parsing/rendering.  This action
#     may be slow (it takes a few seconds to parse).
#   - After doing the MJML processing, the worker uses the Erubis gem to parse and render
#     any ERB tags present.  This is done from the in-memory ERB template string produced
#     by the MJML parser.
#   - Uses the mail gem to send the message to the recipient indicated when enqueing the
#     worker.
class EmailWorker
  include Sidekiq::Worker

  def perform(rcpt='', subj='', msg='')
    # MJML processing.
    mjml_template_file_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'views', 'message.erb.mjml'))
    erb_template = parse_and_render_mjml_template_from_file(mjml_template_file_path)
    # ERB processing.
    html_msg = render_email_message_from_erb_template(erb_template, { :msg => msg })

    # Send email message...
    Mail.deliver do
      from ENV['MAIL_MESSAGE_SENDER']
      to rcpt
      subject subj
      text_part do
        body msg
      end
      html_part do
          content_type 'text/html; charset=UTF-8'
          body html_msg
      end
    end
  end

  private

  def parse_and_render_mjml_template_from_file(mjml_template_file_path)
    template = File.open(mjml_template_file_path, 'rb') do |mjml_file|
      MJML::Parser.new.call mjml_file.read
    end
  end

  def render_email_message_from_erb_template(erb_template, data)
    erb = Erubis::Eruby.new(erb_template)
    erb.result data
  end
end
