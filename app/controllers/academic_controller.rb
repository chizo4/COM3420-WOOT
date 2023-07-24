# frozen_string_literal: true

class AcademicController < ApplicationController
  before_action :authenticate_academic!

  private

  def academic_params; end
end
