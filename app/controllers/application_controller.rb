# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :info, :error, :success

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Disabling caching will prevent sensitive information being stored in the
  # browser cache. If your app does not deal with sensitive information then it
  # may be worth enabling caching for performance.
  before_action :update_headers_to_disable_caching

  private

  def update_headers_to_disable_caching
    response.headers['Cache-Control'] = 'no-cache, no-cache="set-cookie", no-store, private, proxy-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
  end

  # Method sets the default path for an academic after they sign in.
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || academic_menu_index_path
  end
end
