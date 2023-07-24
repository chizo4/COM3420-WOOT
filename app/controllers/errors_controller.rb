# frozen_string_literal: true

# Custom error controller, rendered e.g. when a page is ot found (404).
# It's only enabled on the deployment server.

class ErrorsController < ApplicationController
  layout 'error'

  def show
    @exception = request.env['action_dispatch.exception']
    @status_code = @exception.try(:status_code) ||
                   ActionDispatch::ExceptionWrapper.new(
                     request.env, @exception
                   ).status_code

    render view_for_code(@status_code), status: @status_code
  end

  private

  def view_for_code(code)
    supported_errors.fetch(
      code, '404'
    )
  end

  def supported_errors
    {
      403 => '403',
      404 => '404',
      500 => '500'
    }
  end
end
