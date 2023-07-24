# frozen_string_literal: true

class Academic::ResourcesController < AcademicController
  before_action :load_resources
  before_action :load_shared_quizzes, only: %i[shared]
  before_action :set_current_path

  def index
    return unless params[:query].present?

    # Handle search box filters.
    quizzes = current_academic.quizzes.where(
      'LOWER(name) LIKE ?', "%#{params[:query].downcase}%"
    )
    folders = current_academic.folders.where(
      'LOWER(name) LIKE ?', "%#{params[:query].downcase}%"
    )
    @resources = folders + quizzes
  end

  def load_resources
    folders = current_academic.folders
    quizzes = current_academic.quizzes.where(folder_id: nil)
    @resources = folders + quizzes
  end

  def shared; end

  private

  def load_shared_quizzes
    shared_quizzes = current_academic.sharing
    @shared_resources = shared_quizzes.select { |quiz| quiz.questions.any? }
  end

  def set_current_path
    @current_path = request.path
  end
end
