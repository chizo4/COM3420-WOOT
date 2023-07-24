# frozen_string_literal: true

Sentry.init do |config|
  # Sentry is only enabled when the dsn is set.
  unless Rails.env.development? || Rails.env.test?
    config.dsn = 'https://df7e2836365b40f4a606c86fff003fae@sentry.shefcompsci.org.uk/346'
  end
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.before_send = lambda { |event, _hint|
    ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters).filter(event.to_hash)
  }
  config.excluded_exceptions += [
    'ActionController::BadRequest',
    'ActionController::UnknownFormat',
    'ActionController::UnknownHttpMethod',
    'ActionDispatch::Http::MimeNegotiation::InvalidType',
    'CanCan::AccessDenied',
    'Mime::Type::InvalidMimeType',
    'Rack::QueryParser::InvalidParameterError',
    'Rack::QueryParser::ParameterTypeError',
    'SystemExit',
    'URI::InvalidURIError'
  ]
end
