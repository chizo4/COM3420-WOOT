# frozen_string_literal: true

class Academic::Quizzes::QuestionsController < AcademicController
  before_action :set_quiz, only: %i[create]
  before_action :set_question,
                only: %i[edit update destroy add_answer destroy_answer increase_position decrease_position]

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.quiz_id = @quiz.id

    if @question.save && @question.valid?
      redirect_to academic_quiz_path(@quiz)
      flash[:notice] = 'Successfully created new Question!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params) && @question.valid?
      redirect_to academic_quiz_path(@quiz)
      flash[:notice] = 'Successfully updated the Question!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      flash[:notice] = 'Successfully deleted the Question!'
    else
      flash[:alert] = 'Could not delete the Question!'
    end

    redirect_to academic_quiz_path(@quiz)
  end

  def add_answer
    if @question.nil?
      @question = Question.new(
        question_params.merge({ id: params[:id] })
      )
      @question.answers.build
      render :new, status: :unprocessable_entity
    else
      @question.update(question_params)
      @question.answers.build
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy_answer
    answer = @question.answers.find(params[:answer_id]) if params[:answer_id]
    answer&.destroy
    render :edit, status: :unprocessable_entity
  end

  # Custom method to increase position of a question (if it is not last).
  def increase_position
    if @quiz.questions.length > @question.position && @question.update(position: @question.position + 1)
      next_question = @quiz.questions.find_by(position: @question.position)

      next_question.update(position: next_question.position - 1) if next_question.present?

      redirect_to academic_quiz_path(@question.quiz)
      return
    end

    redirect_to academic_quiz_path(@question.quiz)
    flash[:notice] = 'Could not update the Question position.'
  end

  # Custom method to decrease position of a question (if it is not first).
  def decrease_position
    if @question.position > 1 && @question.update(position: @question.position - 1)
      prev_question = @quiz.questions.find_by(position: @question.position)

      prev_question.update(position: prev_question.position + 1) if prev_question.present?

      redirect_to academic_quiz_path(@question.quiz)
      return
    end

    redirect_to academic_quiz_path(@question.quiz)
    flash[:notice] = 'Could not update the Question position.'
  end

  private

  def set_quiz
    @quiz = current_academic.quizzes.find(params[:quiz_id])
  end

  def set_question
    set_quiz
    return unless params[:id]

    @question = @quiz.questions.find(params[:id])
  end

  # Question params include nested attributes for its answers.
  def question_params
    params.require(:question).permit(
      :content,
      :poll,
      :position,
      :time,
      answers_attributes: %i[
        id content correct _destroy
      ]
    )
  end
end
