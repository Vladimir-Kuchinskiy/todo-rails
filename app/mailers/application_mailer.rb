# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'task.tracker@gmail.com'
  layout 'mailer'
end
