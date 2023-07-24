# frozen_string_literal: true

class Academic::QuizSessionsController < AcademicController
  before_action :set_quiz, only: %i[create]
  before_action :set_quiz_session, only: %i[show destroy next update pause]
  before_action :set_player_sessions, only: %i[show]
  before_action :set_answers, only: %i[show]
  after_action :send_stream, only: %i[update]

  def show
    session[:current_quiz_session_id] = @quiz_session.id
    @current_quiz_session = @quiz_session.to_json(
      include: { quiz: { include: { questions: { include: [:answers] } } } }
    )
  end

  def create
    quiz_session = QuizSession.new
    quiz_session.quiz_id = @quiz.id
    quiz_session.paused = false

    if @quiz.questions.any? && quiz_session.save
      redirect_to academic_quiz_session_path(quiz_session)
      flash[:notice] = 'The Quiz Session has successfully started!'
    else
      redirect_to academic_quiz_path(@quiz)
      flash[:notice] = 'Could not start the Quiz Session, since the Quiz is not complete!'
    end
  end

  def update
    return unless @quiz_session.position <= (@quiz_session.quiz.questions.length + 0.33)

    position = if @quiz_session.position.zero?
                 @quiz_session.position + 1
               else
                 @quiz_session.position + 0.33
               end

    # This is in order to have 3 stages in each question, i.e. show:
    # - question with answers, correct results, leaderboard
    position = if (position % 1).round(2) == 0.99
                 position.round
               else
                 position.round(2)
               end

    paused = @quiz_session.paused = false

    return if @quiz_session.update(position:, paused:)

    flash[:alert] = 'Could not proceed to the next Question!'
  end

  # Method that handles quiz pausing.
  def pause
    paused = @quiz_session.paused = if @quiz_session.paused
                                      false
                                    else
                                      true
                                    end

    if @quiz_session.update(paused:)
      PgPubsub.new('event').publish(
        (Hash[:event, 'pause', :quiz_session, @quiz_session.to_json]).to_json
      )
    else
      flash[:alert] = 'Could not pause the quiz'
    end
  end

  # Method that handles going to the next screen during quiz session.
  def next
    position = @quiz_session.position += 1
    @quiz_session.update(position:)
  end

  def destroy
    @quiz = Quiz.find(@quiz_session.quiz_id)

    if @quiz_session.destroy
      delete_redirect
      flash[:notice] = 'The Quiz Session got successfully stopped!'
    else
      render :show
      flash[:alert] = 'Could not stop the Quiz Session! Please try again.'
    end
  end

  private

  def set_player_sessions
    @player_sessions = PlayerSession.where(quiz_session_id: @quiz_session.id)
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_quiz_session
    @quiz_session = QuizSession.find(params[:id])
  end

  def quiz_session_params
    params.require(:quiz_session).permit(:code, :quiz_id, :position)
  end

  def set_answers
    unless @quiz_session.position.zero?
      @question = @quiz_session.quiz.questions.find_by(position: @quiz_session.position)
    end

    return unless @question.present?

    @answers = @question.answers
  end

  # Stream method responsible for updating the session participants' screens.
  def send_stream
    current_question = @quiz_session.quiz.questions.find_by(position: @quiz_session.position)

    quiz_session_json = @quiz_session.to_json(
      include: { quiz: { methods: :questions_length } }
    )

    selected_answers_json = @quiz_session.selected_answers.to_json(only: %i[id correct])

    question_json = current_question.to_json(include: :answers)

    # Sends the updated_quiz_session and the updated player_sessions
    PgPubsub.new('event').publish(
      (Hash[:event, 'quiz_session', :quiz, quiz_session_json, :question, question_json, :selected_answers,
            selected_answers_json]).to_json
    )

    player_sessions = PlayerSession.where(quiz_session_id: @quiz_session.id)

    return unless player_sessions.any?

    player_session_json = player_sessions.to_json(
      methods: :selected_answer
    )

    PgPubsub.new('event').publish(
      (Hash[:event, 'player_sessions', :players, player_session_json]).to_json
    )
  end

  def delete_redirect
    if current_academic == @quiz.academic
      redirect_to academic_quiz_path(@quiz)
    else
      redirect_to academic_shared_path(current_academic)
    end
  end
end
