class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAILER_SENDER') { 'change-me@example.com' }
  layout 'mailer'
end
