# frozen_string_literal: true

class Academic::QuizzesController < AcademicController
  before_action :set_quiz, only: %i[show edit update destroy]
  before_action :set_folders, only: %i[new edit create update]
  before_action :default_form_attr, only: %i[new edit create update]
  before_action :set_current_path

  def show; end

  def edit
    @form_options = %w[move] if params[:move]
    @current_folder_id = @quiz.folder_id
  end

  def new
    @quiz = Quiz.new
    @current_folder_id = params[:current_folder_id]
  end

  # Custom controller action to preview a quiz (i.e. iterate its questions).
  def preview
    @quiz = current_academic.quizzes.find(params[:quiz_id])
    @questions = @quiz.questions

    if @quiz.questions.any?
      @question = @questions[0]
      @answers = @question.answers
      @quiz_json = @quiz.to_json(
        include: { questions: { include: :answers } }
      )
    else
      redirect_to academic_quiz_path(@quiz)
      flash[:notice] = 'Could not start the Quiz Preview, since the Quiz is not complete!'
    end
  end

  def create
    @quiz = Quiz.new(quiz_params)
    @quiz.academic = current_academic

    if @quiz.save && @quiz.valid?
      redirect_to academic_quiz_path(@quiz)
      flash[:notice] = 'Successfully created new Quiz!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @quiz.update(quiz_params)
      if params[:current_path].nil?
        redirect_to academic_quiz_path(@quiz)
      else
        redirect_to params[:current_path]
      end
      flash[:notice] = 'Successfully updated the Quiz!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @quiz.destroy
      if @quiz.folder_id?
        redirect_to academic_folder_path(@quiz.folder_id)
      else
        redirect_to academic_resources_path
      end
      flash[:notice] = 'Successfully deleted the Quiz!'
    else
      flash[:alert] = 'Could not delete the Quiz!'
      render :show
    end
  end

  private

  def set_quiz
    @quiz = current_academic.quizzes.find(params[:id])
    @questions = @quiz.questions.load
  end

  def set_folders
    @folders = current_academic.folders
    set_folder_options
  end

  def set_folder_options
    folders_array = @folders.all.map { |folder| [folder.name, folder.id] }
    @folder_options = folders_array.append(['No Folder', ''])
  end

  def default_form_attr
    @form_options = %w[rename move]
  end

  def quiz_params
    params.require(:quiz).permit(:name, :folder_id)
  end

  def set_current_path
    @current_path = request.path
  end
end
