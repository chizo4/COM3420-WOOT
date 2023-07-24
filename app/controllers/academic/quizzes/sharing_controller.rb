# frozen_string_literal: true

class Academic::Quizzes::SharingController < AcademicController
  before_action :set_quiz, only: %i[update destroy edit]
  before_action :set_foreign_academic, only: %i[destroy]

  def edit; end

  def update
    email = params[:quiz][:academic_email].chomp
    academic_obj = Academic.find_by(email:)

    if academic_obj.nil? || (@quiz.sharing.include? academic_obj) || (current_academic.email == email)
      flash[:error] = 'Unable to share the Quiz!'
    else
      @quiz.sharing.append(academic_obj)
      flash[:notice] = 'Successfully shared the Quiz!'
    end

    if @quiz.save && @quiz.valid?
      sharing_redirect_path
    else
      flash[:error] = 'Unable to share Quiz'
    end
  end

  def destroy
    return if @quiz.sharing.find(@foreign_academic.id).nil?

    @quiz.sharing.delete(@foreign_academic)

    if @quiz.save && @quiz.valid?
      sharing_redirect_path
      flash[:notice] = 'Successfully un-shared the Quiz!'
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def sharing_redirect_path
    if params[:current_path].nil?
      redirect_to academic_quiz_path(@quiz)
    else
      redirect_to params[:current_path]
    end
  end

  def set_quiz
    @quiz = current_academic.quizzes.find(params[:id])
  end

  def set_foreign_academic
    @foreign_academic = Academic.find_by(email: params[:academic_email])
  end
end
