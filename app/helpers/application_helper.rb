# frozen_string_literal: true

module ApplicationHelper
  # Helper method for page titles (e.g. "WOOT | Home").
  def page_title(title = nil)
    @page_title = title if title
    content_for :title, @page_title
  end
end
