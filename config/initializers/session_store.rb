# frozen_string_literal: true

require 'rack-cas/session_store/rails/active_record'
# frozen_string_literal: true

app_name = 'project'

Rails.application.config.session_store ActionDispatch::Session::RackCasActiveRecordStore,
                                       key: "_#{app_name}_#{Rails.env}_session_id",
                                       secure: !(Rails.env.development? || Rails.env.test?),
                                       httponly: true
