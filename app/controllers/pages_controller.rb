# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :load_file

  def accessibility; end

  def help; end

  private

  # Helper method to load .pdf files for users.
  def load_file
    filename = "#{params[:filename]}.pdf"
    filepath = Rails.root.join('app', 'packs', 'documents', filename)

    if File.exist?(filepath)
      send_file filepath, type: 'application/pdf', disposition: 'inline'
    else
      redirect_to root_path, alert: 'File not found!'
    end
  end
end
