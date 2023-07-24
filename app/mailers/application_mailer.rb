# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@sheffield.ac.uk'
  layout 'mailer'
end
